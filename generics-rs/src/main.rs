#[derive(Debug)]
struct Point<X1, Y1> {
    _x: X1,
    _y: Y1,
}

impl<X1, Y1> Point<X1, Y1> {
    fn mixup<X2, Y2> (self, other: Point<X2, Y2>) -> Point<X1, Y2> {
        Point {
            _x: self._x,
            _y: other._y,
        }
    }
}

fn main() {
    let p1 = Point {_x: 1, _y: 2 };
    let p2 = Point {_x: "one", _y:'2' };
    dbg!(p1.mixup(p2));
}
