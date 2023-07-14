//use generics_rs::{Summary, NewsArticle, Tweet, BlogPost, notify};

fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
fn main() {
    let s1 = "abcd";
    let s2 = "xyz";

    let result = longest(s1, s2);
    println!("The longest string is {}", result);

    //let article = NewsArticle {
    //    headline: String::from("Aliens say 'Hi'"),
    //    location: String::from("USA"),
    //    author: String::from("Jane Earthington"),
    //    content: String::from("Apprently they forgot something here"),
    //};

    //println!("1 new article: {}", article.summarize());

    //let tweet = Tweet {
    //    username: String::from("nasa"),
    //    content: String::from("aliens bro"),
    //    reply: false,
    //    retweet: false,
    //};

    //println!("1 new tweet: {}", tweet.summarize());

    //let blog = BlogPost{};
    //println!("1 new blog: {}", blog.summarize());

    //notify(&article);
}
