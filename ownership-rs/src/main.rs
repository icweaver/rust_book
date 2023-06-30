fn main() {
    let mut s = String::from("hello");
    s.push_str(", world!");
    dbg!(s);

    let x = 5; // Pushed onto stack
    let y = x; // A copy of the data pushed onto stack
    dbg!(x, y);

    let s1 = String::from("hello");
    let s2 = s1;
    dbg!(s1, s2);
}

