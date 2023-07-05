### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 13007fd8-16af-11ee-262b-1d147de47c9d
begin
	using PlutoUI
	using HypertextLiteral: @htl
end

# ╔═╡ ee802ab9-90b5-449b-9df1-9c4dca647ff4
md"""
# Stepping between Julia and Rust

Some quick, disorganized notes as I stumble between the two
"""

# ╔═╡ 5da9a145-7107-4528-8203-f571116fd1bb
md"""
## Style

Semicolons. Semicolons everywhere;

```
do this;
and this;

not this
or this
```

```rust
// Single line comments, similar to #

/* Multi-line
comments similar to #= =#
*/
```

Unless we want to [return a value in a function](#functions)
"""

# ╔═╡ f2f0b0ee-1474-440f-b49d-3bc750c13a66
md"""
## Common Programming Concepts
"""

# ╔═╡ 39f4026f-9c7a-4dd3-9cfd-03db6003e5bc
md"""
### Data types

All pretty analogous to type annotations in Julia, with the exception of `String`s:
"""

# ╔═╡ 289d0a52-9be2-4d85-bdcd-cc0b6b5913dc
md"""
```rust
let tup:(u32, f32, &str) = (42, 42.0, "42"); // Explicit
let tup_inf = (42, 42.0, "42"); // Inferred
```

Tuples accessed through indexing instead of names. Also 0-based =/

```rust
let (x, y, z) = tup_inf;
tup_inf.1; // 42.0
```
"""

# ╔═╡ 6440be4c-053e-4670-9757-e739e49bc357
md"""
#### Arrays
"""

# ╔═╡ a2e28dbc-a822-450c-b5b4-c1882a0e7ada
md"""
Must be homogeneous

```rust
let arr = [1, 10, "20"]; // Will fail
```

Unlike in Julia, arrays are a fixed size from the jump and allocated on the stack! No external package like StaticArrays.jl required. Pretty cool

!!! note
	We can store dynamic arrays on the heap as vectors. This requires some special handling though that is [discussed later in the rust book](https://doc.rust-lang.org/book/ch08-01-vectors.html)

The flipside to automatically static arrays seems to be that we need to explicitly specify its length if we want anything other than the default datatype for our elements

```rust
let arr_exp1:[f32; 3] = [1.0, 10.0, 20.0];
```

Although there may be a [future feature](https://stackoverflow.com/a/72468232) that makes this a bit more convenient

```rust
let arr_exp1:[f32; _] = [1.0, 10.0, 20.0];
```

If indexing an array based on user input, the index must be cast to `usize`. I guess this ensures that it will always work on 32 and 64 bit systems
"""

# ╔═╡ 3110e1f2-80d5-4c6a-8526-86725dbe88ee
md"""
#### Strings

```rust
// Immutable
let s = "hello";

// Mutable
let mut s = String::from("hello");
s.push_str(", world!");
dbg!(s); // s = "hello, world!"
```

More on this in [Ownership](#ownership)
"""

# ╔═╡ 2640a599-30ea-457c-9569-2c531585923d
md"""
### Control flow

The branches of if statments need to return the same type

```rust
let num = 1;
let val = 5;

let x = if num > val {
	1
} else if num < val {
	0.0 // Will fail at compile time
} else {
	-1
};
```

Great for ensuring type stability!
"""

# ╔═╡ de42b816-0c66-4e77-b128-f06285c3d0a6
md"""
### Overview
This is still pretty abstract, so an example:

```rust
{
	let x = 5; // Pushed onto stack
	let y = x; // A "trivial" copy of the data made
	// Do stuff
	dbg!(x, y) // x = 5, y = 5
}

// Other stuff where x and y no longer in use
```

Like in most languages, this creates i) the original data and ii) a copy, and places them in memory[*](#trivial-copy). Since `5` is an integer with known size, both pieces of data can be placed on the stack. Once we leave the scope where they were created, the memory is then popped off the stack one at a time and is free to be used for other things. In contrast to other languages, this similar operation with strings will fail by design:

```rust
let s1 = String::from("hello");
let s2 = s1; // s1 moved to s2.
dbg!(s1, s2); // Will fail because s1 no longer in memory.
```

What happened here is that first `s1` was created and placed on the heap because its size cannot be determined at compile time. Next, `s1` was *moved* into `s2`. This is Rust's own terminology to make it distinct from a *shallow copy*. The difference is that in a shallow copy, both `s1` and `s2` point to the same piece of data, while in a move, not only do they both point to the same piece of data, but `s1` is then marked as invalid. This last bit is very neat because it avoids the common memory allocation error of double freeing once we leave its scope, which can corrupt memory and introduce security vulnerabilities.
"""

# ╔═╡ 12304a91-9688-4bd6-a7d7-3c2c546dff50
md"""
The idea of ownership also applies to the scope of functions!

```rust
let s = String::from("yo");
takes_ownership(s);
dbg!(s); // Can no longer be used, owned by takes_ownership function now

fn takes_ownership(s: String) {
	dbg!(s);
}
```
"""

# ╔═╡ 382a6158-268a-4457-ba75-ce6e35e1edd2
md"""
Now what if we want to pass a value to a function, but not let the function take ownership? Enter *borrowing*
"""

# ╔═╡ 2464b0b3-add4-4e0e-bb61-7c4868655bb3
md"""
### Borrowing and referenes
By example, let's start with a simple function that takes ownership:

```rust
fn main() {
	let s1 = String::from("hello");
    let n = calc_len_owned(s1);
    dbg!(s1, n); // Will fail because s1 is owned by calc_len_owned now
}

fn calc_len_owned(s: String) -> usize {
    s.len()
}
```
"""

# ╔═╡ 25a6e5fc-dc23-4450-96d9-4ad79744571c
md"""
This fails as expected. If we pass a *reference* to `s1` instead, it is still owned in the outer scope, and only *borrowed* in the scope of `calc_len_borrowed`:

```rust
fn main() {
    let s1 = String::from("hello");
    let n = calc_len_borrowed(&s1);
    dbg!(s1, n); // "hello", 5
}

fn calc_len_borrowed(s: &String) -> usize {
    s.len()
}
```
"""

# ╔═╡ e10b33b9-b38d-427f-9c75-20441e52f7a6
md"""
Sweet! We can also mutate references if we like by doing the following:

```rust
fn main() {
    let mut s1 = String::from("hello");
    change(&mut s1);
    dbg!(s1);
}

fn change(s: &mut String) {
    s.push_str(", world");
}
```

Very satisfying
"""

# ╔═╡ 837655d8-4949-44eb-8a7b-6e2ae26c4f8f
md"""
!!! note
	Multiple mutable referenes are not allowed.

	```rust
	let mut s = String::from("hello");
    let r1 = &mut s;
    let r2 = &mut s;
    dbg!(r1, r2); // Fails
	```

	This makes mutations much more controlled and avoids data races.

	```rust
	let mut s = String::from("hello");
    {
        let r1 = &mut s;
        dbg!(r1);
    }
    let r2 = &mut s;
	// Succeeds
	```
"""

# ╔═╡ 95735f94-1c75-461c-a114-bd4cafea64d9
md"""
### Slices

This is a type of reference to strings that lets us take subsets of it. These subsets are of type `&str`

```rust
fn main {
	let mut sentence = String::from("Hello there");
    let word = first_word(&sentence);
    dbg!(word); // Hello
}

fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..] // Return the string if only one word
}
```

Thanks to rust's borrowing and ownership rules, logical errors like below are easily identified at compile time

```rust
let mut sentence = String::from("Hello there");
let word = first_word(&sentence);
sentence.clear();
dbg!(word); // Fails
```

Since `word` is a reference to a portion of `sentence`, any changes to `sentence`, like `sentence.clear();` would make `word` invalid. To keep data from changing out from under us without us realizing, the compiler will throw an error instead
"""

# ╔═╡ 853c4850-9f75-408c-9f1b-d98a84ff444e
md"""
!!! note
	To make our `first_word` function more general, we could have it accept `&str`

	```rust
	fn first_word(s: &str) -> &str {
		...
	}
	```

	Now it can accept things like `"Hello world"`, `"Hello world"[..3]`, etc. in addition to `String::from("Hello world")`
"""

# ╔═╡ 95d4627f-cd12-4694-860a-9ad26b5bf1c7
md"""
## Structs

Pretty similar to Julia, with some nice additional features

```rust
    struct User {
        active: bool, // Field types required
        username: String,
        age: usize,
    }

    let user1 = build_user(String::from("Alice"), 30);

    // Nice field unpacking
	let user2 = User {username: String::from("Bob"), ..user1};

    dbg!(user1.active, user1.username, user1.age);
    dbg!(user2.active, user2.username, user2.age);

    fn build_user(username: String, age:usize) -> User {
        User {
            active: true,
            username,
            age,
        }
    }
```
"""

# ╔═╡ 981414f5-fb8d-47b3-a159-e80ec743d943
md"""
!!! note
	Due to rust's ownership rules, this will fail

	```rust
	let user1 = build_user(String::from("Alice"), 30);
	
	let user2 = User {age:21, ..user1};
	
	dbg!(user1.active, user1.username, user1.age);
	```

	because the String data "Alice" is moved `user1` to `user2`, making `user1` invalid now. The previous case:

	```rust
	let user2 = User {username: String::from("Bob"), ..user1};
	```

	works because `age` is a Stack-Only data type (`u32` in this case), which allows copying via the Copy trait
"""

# ╔═╡ 382c7889-923b-4175-b2ae-c1124b3bea9d
md"""
We can also control the display options for structs, along with some other handy debug options:

```rust
// Implements the Debug trait so that the #? pretty-print option will work
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let scale = 2;
    let rect1 = Rectangle{
        width: dbg!(15*scale), // Can sneak this in here to see what's going on
        height: 50,
    };

    println!("{rect1:#?}");
    println!("Area: {}", area(&rect1));
}

fn area(r: &Rectangle) -> u32 {
    r.width * r.height
}
```

```raw
[src/main.rs:10] 15 * scale = 30
Rectangle {
    width: 30,
    height: 50,
}
Area: 1500
```
"""

# ╔═╡ dfb1743a-1a0a-4661-8dd3-f66b26282310
@htl "<hr>"

# ╔═╡ d06e45b1-be6b-44a9-b87d-9987b5dd20be
# https://github.com/JuliaPluto/PlutoUI.jl/issues/253
macro anchor(text)
    anchid = replace(lowercase(text), r"(\s)" => "-")
    @htl "<a id=\"$anchid\" href=\"#$anchid\" class=\"anchor\"></a>"
end

# ╔═╡ bcc19246-f947-4d33-ab02-f6a91a71af1b
md"""
### Functions $(@anchor "functions")

Type annotations on args required

```rust
fn f2(x: u32) {
    println!("f2 function: {x}");
}
```

Type annotation on function required if returning value

```rust
fn f3() -> u32 {
    5 // No semicolon here because we want to return a value
}
```
"""

# ╔═╡ b9ddf7fd-e23e-4592-9476-bb42145a7914
md"""
## Ownership $(@anchor "ownership")
This is Rust's unique take on memory management. The gist AFAICT is that it avoids the need to rely on a slow garbage collector at runtime or the more error-prone manual memory freeing route, by automating this process for us. It does this by freeing the memory as soon as the variable using the memory goes out of scope.
"""

# ╔═╡ 6219b8f5-df7a-42bc-bc13-d8345b25d12e
md"""
$(@anchor "trivial-copy")
!!! warning "*Aside"
	
	They just call this a "trivial" copy, so not sure if these are both distinct locations in the stack, or just the original data is. May just be an implementation detail.
"""

# ╔═╡ 13723396-21da-43d1-b27c-ea8cbefc6974
TableOfContents(; depth=4)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
PlutoUI = "~0.7.51"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.1"
manifest_format = "2.0"
project_hash = "11e58608bab65beeb6c78bd55bbc9fd3623da2fd"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "4b2e829ee66d4218e0cef22c0a64ee37cf258c29"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "b478a748be27bd2f2c73a7690da219d0844db305"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.51"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─ee802ab9-90b5-449b-9df1-9c4dca647ff4
# ╟─5da9a145-7107-4528-8203-f571116fd1bb
# ╟─f2f0b0ee-1474-440f-b49d-3bc750c13a66
# ╟─39f4026f-9c7a-4dd3-9cfd-03db6003e5bc
# ╟─289d0a52-9be2-4d85-bdcd-cc0b6b5913dc
# ╟─6440be4c-053e-4670-9757-e739e49bc357
# ╟─a2e28dbc-a822-450c-b5b4-c1882a0e7ada
# ╟─3110e1f2-80d5-4c6a-8526-86725dbe88ee
# ╟─bcc19246-f947-4d33-ab02-f6a91a71af1b
# ╟─2640a599-30ea-457c-9569-2c531585923d
# ╟─b9ddf7fd-e23e-4592-9476-bb42145a7914
# ╟─de42b816-0c66-4e77-b128-f06285c3d0a6
# ╟─6219b8f5-df7a-42bc-bc13-d8345b25d12e
# ╟─12304a91-9688-4bd6-a7d7-3c2c546dff50
# ╟─382a6158-268a-4457-ba75-ce6e35e1edd2
# ╟─2464b0b3-add4-4e0e-bb61-7c4868655bb3
# ╟─25a6e5fc-dc23-4450-96d9-4ad79744571c
# ╟─e10b33b9-b38d-427f-9c75-20441e52f7a6
# ╟─837655d8-4949-44eb-8a7b-6e2ae26c4f8f
# ╟─95735f94-1c75-461c-a114-bd4cafea64d9
# ╟─853c4850-9f75-408c-9f1b-d98a84ff444e
# ╟─95d4627f-cd12-4694-860a-9ad26b5bf1c7
# ╟─981414f5-fb8d-47b3-a159-e80ec743d943
# ╟─382c7889-923b-4175-b2ae-c1124b3bea9d
# ╟─dfb1743a-1a0a-4661-8dd3-f66b26282310
# ╟─d06e45b1-be6b-44a9-b87d-9987b5dd20be
# ╠═13723396-21da-43d1-b27c-ea8cbefc6974
# ╠═13007fd8-16af-11ee-262b-1d147de47c9d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
