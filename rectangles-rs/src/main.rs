#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

fn main() {
    let scale = 2;
    let rect1 = Rectangle{
        width: dbg!(15*scale),
        height: 50,
    };

    println!("{rect1:#?}");
    println!("Area: {}", area(&rect1));
    println!("Area: {}", rect1.area());
}

fn area(r: &Rectangle) -> u32 {
    r.width * r.height
}
