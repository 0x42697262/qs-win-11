/** @typedef {{ kind: "number", value: number } | { kind: "name", value: string } | { kind: "symbol", value: string }} Token */
/** @typedef {{ expression: string, value: number, display: string }} Calculation */

const NUMBER_PATTERN = /^(\d+\.?\d*|\.\d+)(e[+-]?\d+)?/i;
const NAME_PATTERN = /^[a-z]+/i;
const SYMBOLS = "+-*/%^(),";
const SYMBOL_ALIASES = Object.freeze({ "×": "*", "÷": "/", "−": "-", "·": "*" });
const OPERATOR_SYMBOLS = "+-*/%^";

/** @type {Readonly<Record<string, number>>} */
const CONSTANTS = Object.freeze({ pi: Math.PI, e: Math.E, tau: Math.PI * 2 });

/** @type {Readonly<Record<string, (...values: number[]) => number>>} */
const FUNCTIONS = Object.freeze({
    sqrt: Math.sqrt,
    cbrt: Math.cbrt,
    abs: Math.abs,
    round: Math.round,
    floor: Math.floor,
    ceil: Math.ceil,
    sin: Math.sin,
    cos: Math.cos,
    tan: Math.tan,
    asin: Math.asin,
    acos: Math.acos,
    atan: Math.atan,
    ln: Math.log,
    log: Math.log10,
    log2: Math.log2,
    exp: Math.exp,
    min: Math.min,
    max: Math.max,
    pow: Math.pow,
});

/**
 * @param {string} text
 * @returns {Token[] | null}
 */
export function tokenize(text) {
    /** @type {Token[]} */
    const tokens = [];
    let rest = text.trim();
    while (rest.length > 0) {
        const head = rest.charAt(0);
        if (/\s/.test(head)) {
            rest = rest.slice(1);
            continue;
        }
        const alias = /** @type {Record<string, string>} */ (SYMBOL_ALIASES)[head];
        if (alias || SYMBOLS.indexOf(head) >= 0) {
            tokens.push({ kind: "symbol", value: alias || head });
            rest = rest.slice(1);
            continue;
        }
        const number = NUMBER_PATTERN.exec(rest);
        if (number) {
            tokens.push({ kind: "number", value: Number(number[0]) });
            rest = rest.slice(number[0].length);
            continue;
        }
        const name = NAME_PATTERN.exec(rest);
        if (name) {
            const digits = /^\d+/.exec(rest.slice(name[0].length));
            const word = digits && (name[0] + digits[0]).toLowerCase() in FUNCTIONS ? name[0] + digits[0] : name[0];
            tokens.push({ kind: "name", value: word.toLowerCase() });
            rest = rest.slice(word.length);
            continue;
        }
        return null;
    }
    return tokens;
}

/**
 * @param {Token[]} tokens
 * @returns {number | null}
 */
export function evaluateTokens(tokens) {
    let position = 0;

    /** @param {string} symbol */
    function accept(symbol) {
        const token = tokens[position];
        if (token && token.kind === "symbol" && token.value === symbol) {
            position += 1;
            return true;
        }
        return false;
    }

    /** @returns {number} */
    function parseSum() {
        let value = parseProduct();
        for (;;) {
            if (accept("+")) {
                value += parseProduct();
            } else if (accept("-")) {
                value -= parseProduct();
            } else {
                return value;
            }
        }
    }

    /** @returns {number} */
    function parseProduct() {
        let value = parseUnary();
        for (;;) {
            if (accept("*")) {
                value *= parseUnary();
            } else if (accept("/")) {
                value /= parseUnary();
            } else if (accept("%")) {
                value %= parseUnary();
            } else {
                return value;
            }
        }
    }

    /** @returns {number} */
    function parseUnary() {
        if (accept("-")) {
            return -parseUnary();
        }
        if (accept("+")) {
            return parseUnary();
        }
        return parsePower();
    }

    /** @returns {number} */
    function parsePower() {
        const base = parseAtom();
        return accept("^") ? Math.pow(base, parseUnary()) : base;
    }

    /** @returns {number} */
    function parseAtom() {
        const token = tokens[position];
        if (!token) {
            throw new Error("end");
        }
        position += 1;
        if (token.kind === "number") {
            return token.value;
        }
        if (token.kind === "symbol" && token.value === "(") {
            const value = parseSum();
            if (!accept(")")) {
                throw new Error("paren");
            }
            return value;
        }
        if (token.kind === "name" && token.value in FUNCTIONS && accept("(")) {
            /** @type {number[]} */
            const values = [parseSum()];
            while (accept(",")) {
                values.push(parseSum());
            }
            if (!accept(")")) {
                throw new Error("paren");
            }
            return FUNCTIONS[token.value].apply(null, values);
        }
        if (token.kind === "name" && token.value in CONSTANTS) {
            return CONSTANTS[token.value];
        }
        throw new Error("token");
    }

    try {
        const value = parseSum();
        return position === tokens.length && Number.isFinite(value) ? value : null;
    } catch (error) {
        return null;
    }
}

/**
 * @param {number} value
 * @param {number} significantDigits
 * @returns {string}
 */
export function formatResult(value, significantDigits) {
    const rounded = Number(value.toPrecision(Math.max(1, Math.round(significantDigits))));
    return rounded === 0 ? "0" : String(rounded);
}

/**
 * @param {string} query
 * @param {number} significantDigits
 * @returns {Calculation | null}
 */
export function calculate(query, significantDigits) {
    const expression = query.trim().replace(/^=/, "").trim();
    const tokens = tokenize(expression);
    if (!tokens || tokens.length < 2) {
        return null;
    }
    const computes = tokens.some(token => (token.kind === "symbol" && OPERATOR_SYMBOLS.indexOf(token.value) >= 0) || (token.kind === "name" && token.value in FUNCTIONS));
    if (!computes) {
        return null;
    }
    const value = evaluateTokens(tokens);
    return value === null ? null : { expression, value, display: formatResult(value, significantDigits) };
}
