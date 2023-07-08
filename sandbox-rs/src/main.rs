fn main() {
    let mut v = vec![6, 7, 8];

    while let Some(x) = v.pop().flatten() {
        dbg!(x);
    }
}
