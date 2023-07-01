fn main() {
    //let s1 = String::from("hello");
    //let n = calc_len_owned(s1);
    //dbg!(s1, n);

    //let s1 = String::from("hello");
    //let n = calc_len_borrowed(&s1);
    //dbg!(s1, n);

    //let mut s1 = String::from("hello");
    //change(&mut s1);
    //dbg!(s1);

    let mut s = String::from("hello");
    {
        let r1 = &mut s;
        dbg!(r1);
    }
    let r2 = &mut s;
    dbg!(r2);
}

//fn calc_len_owned(s: String) -> usize {
//    s.len()
//}
//
//fn calc_len_borrowed(s: &String) -> usize {
//    s.len()
//}
//
//fn change(s: &mut String) {
//    s.push_str(", world");
//}
