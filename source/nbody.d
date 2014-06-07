// Written in the D programming language.
/**
*   The Computer Language Benchmarks Game
*   http://benchmarksgame.alioth.debian.org/
*
*   Copyright: Anton Gushcha 2014
*   License: Boost License 1.0.
*/
module nbody;

import std.conv;
import std.math;
import std.stdio;

enum SolarMass = 4.0 * PI * PI;
enum Year = 365.24;
enum PlanetNum = 5;

struct Planet
{
    double x, y, z;
    double vx, vy, vz;
    double mass;
}

__gshared Planet[PlanetNum] nbodies = [
    // Sun
    Planet(
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        SolarMass
    ),
    // Jupiter
    Planet(
        4.84143144246472090e+00,
        -1.16032004402742839e+00,
        -1.03622044471123109e-01,
        
        1.66007664274403694e-03 * Year,
        7.69901118419740425e-03 * Year,
        -6.90460016972063023e-05 * Year,
        
        9.54791938424326609e-04 * SolarMass
    ),
    // Saturn
    Planet(
        8.34336671824457987e+00,
        4.12479856412430479e+00,
        -4.03523417114321381e-01,
        
        -2.76742510726862411e-03 * Year,
        4.99852801234917238e-03 * Year,
        2.30417297573763929e-05 * Year,
        
        2.85885980666130812e-04 * SolarMass
    ),
    // Uranus
    Planet(
        1.28943695621391310e+01,
        -1.51111514016986312e+01,
        -2.23307578892655734e-01,
        
        2.96460137564761618e-03 * Year,
        2.37847173959480950e-03 * Year,
        -2.96589568540237556e-05 * Year,
        
        4.36624404335156298e-05 * SolarMass
    ),
    // Neptune
    Planet(
        1.53796971148509165e+01,
        -2.59193146099879641e+01,
        1.79258772950371181e-01,
        
        2.68067772490389322e-03 * Year,
        1.62824170038242295e-03 * Year,
        -9.51592254519715870e-05 * Year,
        
        5.15138902046611451e-05 * SolarMass
    )
];

void advance(ref Planet[PlanetNum] bodies, double dt, size_t steps)
{
    foreach(n; 0 .. steps)
    {
        foreach(i, ref bi; bodies)
        {
            foreach(ref bj; bodies[i+1 .. $])
            {
                double dx = bi.x - bj.x;
                double dy = bi.y - bj.y;
                double dz = bi.z - bj.z;
                double distance = sqrt(dx * dx + dy * dy + dz * dz);
                double mag = dt / (distance * distance * distance);
                bi.vx -= dx * bj.mass * mag;
                bi.vy -= dy * bj.mass * mag;
                bi.vz -= dz * bj.mass * mag;
                bj.vx += dx * bi.mass * mag;
                bj.vy += dy * bi.mass * mag;
                bj.vz += dz * bi.mass * mag;
            }
        }
        foreach(ref b; bodies)
        {
            b.x += dt * b.vx;
            b.y += dt * b.vy;
            b.z += dt * b.vz;
        }
    }
}

void offset_momentum(ref Planet[PlanetNum] bodies)
{
    double px = 0.0, py = 0.0, pz = 0.0;
    foreach(ref b; bodies)
    {
        px += b.vx * b.mass;
        py += b.vy * b.mass;
        pz += b.vz * b.mass;
    }
    bodies[0].vx = - px / SolarMass;
    bodies[0].vy = - py / SolarMass;
    bodies[0].vz = - pz / SolarMass;
}

double energy(ref Planet[PlanetNum] bodies)
{
    double e = 0.0;
    foreach(i, ref bi; bodies)
    {
        e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);
        foreach(ref bj; bodies[i+1 .. $])
        {
            double dx = bi.x - bj.x;
            double dy = bi.y - bj.y;
            double dz = bi.z - bj.z;
            double distance = sqrt(dx * dx + dy * dy + dz * dz);
            e -= (bi.mass * bj.mass) / distance;
        }
    }
    return e;
}

void main(string[] args)
{
    size_t n = args.length == 1 ? 5000000 : args[1].to!size_t;
    
    offset_momentum(nbodies);
    writefln("%.9f", energy(nbodies));
    advance(nbodies, 0.01, n);
    writefln("%.9f", energy(nbodies));
}