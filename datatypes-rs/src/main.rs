fn main() {
    let x: u32 = "42".parse().expect("Not a number");
    let y = x / 2; // x / 2.0 will fail because types are not automatically promoted
    dbg!(x, y);

    let x = 5;
    let y = x / 3; // Truncates (rounds down) to 1
    dbg!(x, y);

    let t = true;
    let f:bool = false; // f:bool = 0 not allowed
    dbg!(t, f);

    let c = 'c';
    let s:&str = "yea"; // Doesn't allow 'yea', huzzah!
                        // &str puts a pointer on the stack.
                        // Otherwise, size of "42" cannot be known
                        // at compile time and error will be thrown
    dbg!(c, s);

    let tup:(u32, f32, &str) = (42, 42.0, "42");
    let tup_inf = (42, 42.0, "42"); // Can also be inferred
    let (x, y, z) = tup_inf; // And unpacked
    dbg!(tup, tup_inf, x, y, z, tup_inf.1); // Tuples accessed through 0-based indexing =/
                                            //
    let arr_inf1 = [1, 10, 20];
    let arr_inf2 = [3; 4];
    let arr_exp1:[f32; 3] = [1.0, 10.0, 20.0];
    let arr_exp2:[_; 3] = [1.0f32, 10.0, 20.0];
    dbg!(arr_inf1, arr_inf2, arr_exp1, arr_exp2);
}
