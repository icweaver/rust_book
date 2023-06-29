fn main() {
    println!("main function");

    f2(4);

    let yee = f3();
    println!("f3 function: {yee}");
}

fn f2(x: u32) {
    println!("f2 function: {x}");
}

fn f3() -> u32 {
    5
}
