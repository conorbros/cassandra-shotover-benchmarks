use anyhow::{anyhow, Result};
use bench_list::benches_list;
use clap::Parser;
use std::env;
use subprocess::{Exec, Redirection};

mod bench_list;

/// e.g.
/// cargo run --release -- -r 130000
#[derive(Parser, Clone)]
#[clap(name = "cassandra_bench", arg_required_else_help = true)]
pub struct Args {
    #[clap(short, long)]
    pub rate: u64,

    #[clap(short, long)]
    pub shotover_address: String,

    #[clap(short, long)]
    pub direct_address: String,

    #[clap(short, long)]
    pub time: String,

    #[clap(short, long)]
    pub connections: u64,
}

fn main() {
    let args = Args::parse();

    // The benches and tests automatically set the working directory to CARGO_MANIFEST_DIR.
    // We need to do the same as the DockerCompose + ShotoverManager types rely on this.
    std::env::set_current_dir(env!("CARGO_MANIFEST_DIR")).unwrap();

    let latte = Latte::new(args.rate);

    let direct_address = format!("{}:9042", args.direct_address);
    let shotover_address = format!("{}:9043", args.shotover_address);

    let threads = 4;

    // Read benches
    for bench in benches_list() {
        let bench_name = format!("workloads/{bench}");

        println!("{bench}: Benching Shotover ...");
        latte.bench(
            &bench_name,
            &format!("{}-Shotover", bench_name),
            &direct_address,
            &shotover_address,
            &args.time,
            args.connections,
            threads,
        );

        println!("{bench}: Benching Direct Cassandra ...");
        latte.bench(
            &bench_name,
            &format!("{}-Cassandra", bench_name),
            &direct_address,
            &direct_address,
            &args.time,
            args.connections,
            threads,
        );

        println!("{bench}: Direct Cassandra (A) vs Shotover (B)");
        latte.compare(
            &format!(
                "{bench_name}-Cassandra-rate_{}-connections_{}-duration_{}-threads_{}.json",
                args.rate, args.connections, args.time, threads
            ),
            &format!(
                "{bench_name}-Shotover-rate_{}-connections_{}-duration_{}-threads_{}.json",
                args.rate, args.connections, args.time, threads
            ),
        );
    }
}

struct Latte {
    rate: u64,
}

impl Latte {
    fn new(rate: u64) -> Latte {
        run_command(
            "cargo",
            &["install", "--git", "https://github.com/pkolaczk/latte"],
        )
        .unwrap();
        Latte { rate }
    }

    fn bench(
        &self,
        name: &str,
        output_name: &str,
        address_load: &str,
        address_bench: &str,
        duration: &str,
        connections: u64,
        threads: u64,
    ) {
        run_command(
            "latte",
            &[
                "schema",
                "--user",
                "cassandra",
                "--password",
                "cassandra",
                &format!("{name}.rn"),
                "--",
                address_load,
            ],
        )
        .unwrap();
        run_command(
            "latte",
            &[
                "load",
                "--user",
                "cassandra",
                "--password",
                "cassandra",
                &format!("{name}.rn"),
                "--",
                address_load,
            ],
        )
        .unwrap();

        run_command(
            "latte",
            &[
                "run",
                "--user",
                "cassandra",
                "--password",
                "cassandra",
                "--threads",
                &threads.to_string(),
                "--rate",
                &self.rate.to_string(),
                "--duration",
                duration, // default is 60s but 15 seems fine
                "--connections",
                &connections.to_string(), // Shotover performs extremely poorly with 1 connection and this is not currently an intended usecase
                "--output",
                &format!(
                    "{output_name}-rate_{}-connections_{}-duration_{}-threads_{}.json",
                    self.rate, connections, duration, threads
                ),
                &format!("{name}.rn"),
                "--",
                address_bench,
            ],
        )
        .unwrap();
    }

    fn compare(&self, first: &str, second: &str) {
        run_command_to_stdout("latte", &["show", first, "-b", second]);
    }
}

/// unlike `run_command` stdout of the command is sent to the stdout of the application
fn run_command_to_stdout(command: &str, args: &[&str]) {
    assert!(
        std::process::Command::new(command)
            .args(args)
            .status()
            .unwrap()
            .success(),
        "Failed to run: {command} {args:?}"
    );
}

/// Runs a command and returns the output as a string.
///
/// Both stderr and stdout are returned in the result.
///
/// # Arguments
/// * `command` - The system command to run
/// * `args` - An array of command line arguments for the command
///
pub fn run_command(command: &str, args: &[&str]) -> Result<String> {
    println!("executing {}", command);
    let data = Exec::cmd(command)
        .args(args)
        .stdout(Redirection::Pipe)
        .stderr(Redirection::Merge)
        .capture()?;

    if data.exit_status.success() {
        Ok(data.stdout_str())
    } else {
        Err(anyhow!(
            "command {} {:?} exited with {:?} and output:\n{}",
            command,
            args,
            data.exit_status,
            data.stdout_str()
        ))
    }
}
