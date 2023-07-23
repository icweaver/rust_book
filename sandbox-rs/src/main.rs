#[derive(Debug)]
struct LightSeq {
    head: usize,
    seq: [[isize; 2]; 25],
}

fn main() {
    let mut light_seq = LightSeq{
        head: 0,
        seq: [[0, 0]; 25],
    };
    let mut u = [0, 0];
    let mut v = [1, 0];
    //let mut light_seq = [[0, 0]; 25];

    stroke(&mut light_seq, &mut u, v, 4);
    turn_right(&mut v);
    stroke(&mut light_seq, &mut u, v, 4);
    turn_right(&mut v);
    //stroke(&mut light_seq, &mut u, v, 4);
    //turn_right(&mut v);
    //stroke(&mut light_seq, &mut u, v, 4);
    dbg!(light_seq);

    //println!("{:?}", light_seq);
}

fn stroke(
    light_seq: &mut LightSeq,
    //light_seq: &mut [[isize; 2]; 25],
    u: &mut [isize; 2],
    v: [isize; 2],
    n: isize,
) {
    let mut i = light_seq.head;
    for _ in 1..=n {
        // Note: x and y are swapped in the matrix -> nested vector mental model
        u[0] += v[1];
        u[1] += v[0];
        let head = i as usize + light_seq.head;
        light_seq.seq[head] = *u;
        i += 1;
    }
    light_seq.head = i;
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
