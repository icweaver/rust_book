fn main() {
    struct User {
        active: bool,
        username: String,
        age: usize,
    }


    let user1 = build_user(String::from("Alice"), 30);

    let user2 = User {username: String::from("Bob"), ..user1};
    //let user2 = User {age:21, ..user1};

    dbg!(user1.active, user1.username, user1.age);
    dbg!(user2.active, user2.username, user2.age);

    struct Color(i32, i32, i32);
    struct Point(f32, f32);

    let black = Color(0, 5, 0);
    let coord = Point(0.5, 0.0);

    dbg!(black.1, coord.0);

    fn build_user(username: String, age:usize) -> User {
        User {
            active: true,
            username,
            age,
        }
    }
}
