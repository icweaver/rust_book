use std::{env, process};

use minigrep::Config;

fn main() {
    let args: Vec<String> = env::args().collect();

    let config = Config::build(&args).unwrap_or_else(|err| {
        println!("Error parsing command line args: {err}");
        process::exit(1);
    });

    // Using this instead of `.unrap_or_else` because we do not care
    // about the successful unit return type of `run` here,
    // only the return type of the error case
    if let Err(e) = minigrep::run(config) {
        println!("Error searching: {e}");
        process::exit(1);
    }

}
