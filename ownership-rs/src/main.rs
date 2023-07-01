fn main() {
    //let s1 = String::from("hello");
    //let n = calc_len_owned(s1);
    //dbg!(s1, n);

    //let s1 = String::from("hello");
    //let n = calc_len_borrowed(&s1);
    //dbg!(s1, n);

    let mut s1 = String::from("hello");
    change(&mut s1);
    dbg!(s1);
}

fn calc_len_owned(s: String) -> usize {
    s.len()
}

fn calc_len_borrowed(s: &String) -> usize {
    s.len()
}

fn change(s: &mut String) {
    s.push_str(", world");
}
