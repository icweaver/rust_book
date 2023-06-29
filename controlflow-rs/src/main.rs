fn main() {
    let num = 1;
    let val = 5;

    let mut x = if num > val {
        1
    } else if num < val {
        0
    } else {
        -1
    };

    dbg!(x);

    loop {
        x += 1;

        if x == 11 {break};
    }

    dbg!(x);

    for i in (1..=10).rev() {
        println!("{i}");
    }

    // let x = if num > 5 {10} else {"low"};

    // println!("{x}");
}
