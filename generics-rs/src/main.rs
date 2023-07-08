use std::cmp::PartialOrd;

fn largest<T: PartialOrd>(list: &[T]) -> &T {
    let mut largest = &list[0];

    for item in list {
        if item > largest {
            largest = item;
        }
    }

    largest
}

#[derive(Debug)]
struct Point<T> {
    x: T,
    y: T,
}

//impl<T> Point<T> {
//    fn x(&self) -> &T {
//        &self.x
//    }
//    fn y(&self) -> &T {
//        &self.y
//    }
//}

impl Point<f32> {
    fn x(&self) -> &f32 {
        &self.x
    }
    fn y(&self) -> &f32 {
        &self.y
    }
}

fn main() {
    let number_list = vec![34, 50, 25, 100, 65];
    let result = largest(&number_list);
    println!("The largest number is {}", result);

    let char_list = vec!['s', 'u', 'p'];
    let result = largest(&char_list);
    println!("The largest char is {}", result);

    let p_int = Point {x: 5, y: 10};
    println!("{p_int:?}");

    let p_float = Point {x: 4.0, y: 42.0};
    println!("{p_float:?}");


    // println!("{}", p_int.x());
    println!("{}", p_float.y());
}
