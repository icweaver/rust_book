use std::{env, process};

use minigrep::Config;

fn main() {

    // Switching to iterators to avoid the cloning
    // let args: Vec<String> = env::args().collect();
    // let config = Config::build(&args).unwrap_or_else(|err| {
    let config = Config::build(env::args()).unwrap_or_else(|err| {
        eprintln!("Error parsing command line args: {err}");
        process::exit(1);
    });

    // Using this instead of `.unrap_or_else` because we do not care
    // about the successful unit return type of `run` here,
    // only the return type of the error case
    if let Err(e) = minigrep::run(config) {
        eprintln!("Error searching: {e}");
        process::exit(1);
    }

}
