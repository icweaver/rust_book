use std::{env, fs, process};
use std::error::Error;

fn main() {
    let args: Vec<String> = env::args().collect();

    let config = Config::build(&args).unwrap_or_else(|err| {
        println!("Problem parsing arguments: {err}");
        process::exit(1);
    });

    println!("Searching for {}", config.query);
    println!("In file {}", config.file_path);

    // Using this instead of `.unrap_or_else` because we do not care
    // about the successful unit return type of `run` here,
    // only the return type of the error case
    if let Err(e) = run(config) {
        println!("Application error: {e}");
        process::exit(1);
    }

}

fn run(config: Config) -> Result<(), Box<dyn Error>> {
    let contents = fs::read_to_string(config.file_path)?;

    println!("With text:\n{contents}");

    Ok(())
}

struct Config {
    query: String,
    file_path: String,
}

impl Config {
    fn build(args: &[String]) -> Result<Config, &'static str> {
        if args.len() < 3 {
            return Err("not enough arguments");
        }
        let query = args[1].clone(); // Avoids dealing with lifetimes
        let file_path = args[2].clone(); // Can optimize later

        Ok(Config { query, file_path })
    }
}
