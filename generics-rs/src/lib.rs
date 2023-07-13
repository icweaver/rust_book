pub trait Summary {
    // Fallback
    fn summarize_author(&self) -> String {
        format!("[implement later]")
    }

    fn summarize(&self) -> String {
        format!("(Read more from {}...)", self.summarize_author())
    }
}

pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

#[derive(Debug)]
pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    //fn summarize(&self) -> String {
    //    format!("{}, by {} ({})", self.headline, self.author, self.location)
    //}
    fn summarize_author(&self) -> String {
        format!("{}", self.author)
    }
}

pub struct BlogPost{}
impl Summary for BlogPost {}

#[derive(Debug)]
pub struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: bool,
    pub retweet: bool,
}

impl Summary for Tweet {
    fn summarize_author(&self) -> String {
        format!("@{}", self.username)
    }
    //fn summarize(&self) -> String {
    //    format!("{}: {}", self.username, self.content)
    //}
}
