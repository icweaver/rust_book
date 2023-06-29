fn main() {
    let x = 2; // Outer scope

    { // Inner scope
        let x = x + 1;
        println!("Inner: {x}");
    }

    println!("Outer: {x}");

    let spaces = "    ";
    println!("String: {spaces}");


    // We can change types with let
    let spaces = spaces.len();
    println!("Integer: {spaces}");
}
