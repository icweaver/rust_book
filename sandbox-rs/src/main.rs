fn main() {
    #[derive(Debug)]
    struct Vec2 {
        x: f64,
        _y: f64
    }

    let v = Vec2 {x: 3.0, _y:6.0};

    let Vec2 {x, ..} = v;

    dbg!(x);

    dbg!(v);
}
