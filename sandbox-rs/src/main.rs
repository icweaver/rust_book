fn main() {
    let mut u = [0, 0];
    let mut v = [1, 0];

    let mut light_seq = vec![u];

    stroke(&mut light_seq, &mut u, v, 4);
    turn_right(&mut v);
    stroke(&mut light_seq, &mut u, v, 4);
    turn_right(&mut v);
    stroke(&mut light_seq, &mut u, v, 4);
    turn_right(&mut v);
    stroke(&mut light_seq, &mut u, v, 4);

    println!("{:?}", light_seq);
}

fn stroke(
    light_seq: &mut Vec<[isize; 2]>,
    u: &mut [isize; 2],
    v: [isize; 2],
    n: isize,
) {
    for _ in 1..=n {
        // Note: x and y are swapped in the matrix -> nested vector mental model
        u[0] += v[1];
        u[1] += v[0];
        light_seq.push(*u);
    }
}

fn turn_right(
    v: &mut [isize; 2],
) {
    let (vx, vy) = match (v[0], v[1]) {
        (1, 0) => (0, 1),
        (0, 1) => (-1, 0),
        (-1, 0) => (0, -1),
        (0, -1) => (1, 0),
        _ => panic!("Only 90 degree cw turns supported.")
    };

    v[0] = vx;
    v[1] = vy;
}
