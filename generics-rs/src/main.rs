use generics_rs::{Summary, NewsArticle, Tweet, BlogPost, notify};

fn main() {
    let article = NewsArticle {
        headline: String::from("Aliens say 'Hi'"),
        location: String::from("USA"),
        author: String::from("Jane Earthington"),
        content: String::from("Apprently they forgot something here"),
    };

    println!("1 new article: {}", article.summarize());

    let tweet = Tweet {
        username: String::from("nasa"),
        content: String::from("aliens bro"),
        reply: false,
        retweet: false,
    };

    println!("1 new tweet: {}", tweet.summarize());

    let blog = BlogPost{};
    println!("1 new blog: {}", blog.summarize());

    notify(&article);
}
