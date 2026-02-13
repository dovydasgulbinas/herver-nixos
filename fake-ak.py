def ak_kontrolinis(pirmi10: str) -> int:
    a = [int(c) for c in pirmi10]
    w1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1]
    s1 = sum(x * w for x, w in zip(a, w1))
    r1 = s1 % 11
    if r1 != 10:
        return r1

    w2 = [3, 4, 5, 6, 7, 8, 9, 1, 2, 3]
    s2 = sum(x * w for x, w in zip(a, w2))
    r2 = s2 % 11
    return r2 if r2 != 10 else 0


def ak_visas(pirmi10: str) -> int:
    return f"{pirmi10}{ak_kontrolinis(pirmi10)}"


print(ak_visas("3930303333"))
print(ak_visas("3940218114"))
