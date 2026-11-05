import { test } from "node:test";
import assert from "node:assert/strict";
import { calculate, formatResult, tokenize } from "../../src/domain/search/calculator.mjs";

const DIGITS = 12;

test("arithmetic follows precedence and parentheses", () => {
    assert.equal(calculate("2+3*4", DIGITS)?.value, 14);
    assert.equal(calculate("(2+3)*4", DIGITS)?.value, 20);
    assert.equal(calculate("2^3^2", DIGITS)?.value, 512);
    assert.equal(calculate("-2^2", DIGITS)?.value, -4);
    assert.equal(calculate("10 % 4", DIGITS)?.value, 2);
    assert.equal(calculate("= 7 × 6 ÷ 2", DIGITS)?.value, 21);
});

test("functions and constants", () => {
    assert.equal(calculate("sqrt(16)+abs(-2)", DIGITS)?.value, 6);
    assert.equal(calculate("log2(8)", DIGITS)?.value, 3);
    assert.equal(calculate("max(1, 5, 3)", DIGITS)?.value, 5);
    assert.equal(calculate("pi*2", DIGITS)?.display, "6.28318530718");
});

test("plain words, numbers and broken input are not calculations", () => {
    assert.equal(calculate("firefox", DIGITS), null);
    assert.equal(calculate("42", DIGITS), null);
    assert.equal(calculate("c++", DIGITS), null);
    assert.equal(calculate("2+", DIGITS), null);
    assert.equal(calculate("(1+2", DIGITS), null);
    assert.equal(calculate("1/0", DIGITS), null);
    assert.equal(calculate("alert(1)", DIGITS), null);
    assert.equal(tokenize("2 $ 3"), null);
});

test("results round to significant digits", () => {
    assert.equal(calculate("0.1+0.2", DIGITS)?.display, "0.3");
    assert.equal(formatResult(-0, DIGITS), "0");
    assert.equal(formatResult(1 / 3, 4), "0.3333");
});
