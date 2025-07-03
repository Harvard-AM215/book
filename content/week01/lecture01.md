# Lecture 1: Introduction to Mathematical Modeling

## What is Mathematical Modeling?

Mathematical modeling is the process of creating mathematical representations of real-world phenomena to understand, predict, or control them.

## A Simple Example

Consider population growth. The simplest model is exponential growth:

```{math}
:label: exponential-growth
\frac{dP}{dt} = rP(t)
```

where $P(t)$ is the population at time $t$ and $r$ is the growth rate.

## Implementation

```{code-cell} python
import numpy as np
import matplotlib.pyplot as plt

def exponential_growth(P0, r, t):
    """Exponential growth model"""
    return P0 * np.exp(r * t)

# Parameters
P0 = 100  # Initial population
r = 0.1   # Growth rate
t = np.linspace(0, 50, 100)

# Calculate and plot
P = exponential_growth(P0, r, t)
plt.figure(figsize=(8, 5))
plt.plot(t, P, 'b-', linewidth=2)
plt.xlabel('Time')
plt.ylabel('Population')
plt.title('Exponential Population Growth')
plt.grid(True, alpha=0.3)
plt.show()
```

## Summary

This simple model demonstrates key concepts we'll build upon throughout the course.
