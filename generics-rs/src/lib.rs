pub trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}

#[derive(Debug)]
pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

//impl NewsArticle {
//    pub fn summarize(&self) -> String {
//        format!("{}, by {} ({})", self.headline, self.author, self.location)
//    }
//}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
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

//impl Tweet {
//    pub fn summarize(&self) -> String {
//        format!("{}: {}", self.username, self.content)
//    }
//}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}
