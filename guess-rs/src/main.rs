use std::io::{self, Write};
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    let secret_num = rand::thread_rng().gen_range(1..=10);

    println!("**Guess the number**");

    loop {
        print!("Enter guess: ");
        io::stdout().flush().unwrap();


        let mut guess = String::new();

        io::stdin()
            .read_line(&mut guess)
            .expect("Failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(x) => x,
            Err(_) => continue,
        };

        match guess.cmp(&secret_num) {
            Ordering::Less => println!("Too low =("),
            Ordering::Greater => println!("Too high =0"),
            Ordering::Equal => {println!("Perfect =D"); break;},
        };
    };
}
