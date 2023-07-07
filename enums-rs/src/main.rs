fn main() {
    let m = Message::Move {x: 10, y:20 };
    m.call();
}

#[derive(Debug)]
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

impl Message {
    fn call(&self) {
        println!("I'm being called: {self:?}");
    }
}
