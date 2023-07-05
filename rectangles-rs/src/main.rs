#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }

    fn square(size: u32) -> Self {
        Self {
            width: size,
            height: size,
        }
    }
}

fn main() {
    let scale = 2;
    let rect1 = Rectangle{
        width: dbg!(15*scale),
        height: 50,
    };
    let rect2 = Rectangle {width: 1, height: 2};

    println!("{rect1:#?}");
    println!("Area: {}", area(&rect1));
    println!("Area: {}", rect1.area());
    println!("Can hold: {}", rect1.can_hold(&rect2));

    let sq = Rectangle::square(3);
    dbg!(sq);
}

fn area(r: &Rectangle) -> u32 {
    r.width * r.height
}
