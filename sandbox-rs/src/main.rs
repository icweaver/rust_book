fn main() {
    let s = ":) ?";
    let x = is_yelling(s);

    println!("{:?}", x);
}

fn is_question(s: &str) -> bool {
    s.chars().last().unwrap() == '?'
}

fn is_yelling(s: &str) -> bool {
    let mut y = s.chars()
    .filter(|c| c.is_alphabetic()).peekable();

    y.all(|c| c.is_uppercase()) && y.peek().is_some()
}

fn is_silent(s: &str) -> bool {
    s.trim().is_empty()
}
