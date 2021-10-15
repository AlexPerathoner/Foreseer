# Foreseer

Given a sequence of elements, foreseer tries to predict the next elements.

## How it works
Foreseer searches for a pattern previously seen in the input sequence. It then gets the following elements (which should therefore happen in the future) and calculates the probability that each of them presents again.

Let's see look at some examples:

- Consider this input: `010`:

	1. The last element is `0`.
	2. In the "past" there has already been an occurence of `0`. That time it was followed by `1`.
	3. We therefore predict that the next value will be `1` again.

- Consider this input: `0100`:

	1. The last element is `0`.
	2. In the "past" there have been two occurences of `0`. Once it was followed by `1`, once by `0`.
	3. We therefore predict that the next value will be either `1` or `0`, with 50% chance, respectively.

- Consider this input: `11101001`:

	1. The last elements are `01`.
	2. In the "past" there has been one occurence of `01`.
	3. `01` has always been followed by `0`, so we could output `01` with 100% chance.
	4. However, we can also consider `1` as the last element.
	5. In the "past" there have been many occurences of `1`.
	6. `1` has been followed twice by `1` and once by `0`.
	7. By combining these results we get that the next element could be `1` or `0`, with 50% chance, respectively.

## How to use
1. Open `main.swift`
2. Edit the sequence
3. Choose how many items you want to predict
4. Open a terminal and run `swift main.swift`

## License

You can use whatever you want. Just give credits :3
