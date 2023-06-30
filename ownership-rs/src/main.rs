fn main() {
    let s = "hello";
    dbg!(s);

    let mut s = String::from("hello");
    s.push_str(", world!");
    dbg!(s);

    let x = 5; // Pushed onto stack
    let y = x; // A copy of the data pushed onto stack
    dbg!(x, y);

    /*let s1 = String::from("hello");
    let s2 = s1; // s1 moved to s2.
    dbg!(s1, s2); // Will fail because s1 no longer in memory.*/

    let s = String::from("yo");
    // takes_ownership(s);
    let s2 = takes_and_gives_back_ownership(s);
    dbg!(s2); // Can no longer be used, owned by takes_ownership function now

    fn takes_ownership(s: String) {
        dbg!(s);
    }

    fn takes_and_gives_back_ownership(s: String) -> String {
        s
    }
}

