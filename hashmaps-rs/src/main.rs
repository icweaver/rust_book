use std::collections::HashMap;

// A comment
fn main() {
    let mut scores = HashMap::new();

    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);

    let team_name = String::from("Bluee");
    let score = scores.get(&team_name);
    dbg!(score);
}
