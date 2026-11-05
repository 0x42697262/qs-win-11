export const SYMBOL_GROUPS = Object.freeze([
    { name: "punctuation", symbols: "‘’“”«»‹›–—…·•¶§†‡※¡¿‽" },
    { name: "currency", symbols: "€£¥¢₹₩₽₺₫₱₿$" },
    { name: "math", symbols: "±×÷≈≠≤≥∞√∑∏∫∂∆∇∈∉∩∪⊂⊃∧∨¬∀∃°‰′″½⅓¼¾" },
    { name: "arrows", symbols: "←↑→↓↔↕↖↗↘↙⇐⇑⇒⇓⇔↩↪↺↻" },
    { name: "latin", symbols: "ÀÁÂÄÃÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÖØŒÙÚÛÜßàáâäãåæçèéêëìíîïñòóôöøœùúûüÿ" },
    { name: "greek", symbols: "ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψω" },
    { name: "technical", symbols: "©®™℠℃℉№⌘⌥⇧⌃⎋⏎⌫✓✔✗✘★☆♠♣♥♦" },
]);

export const KAOMOJI = Object.freeze(["(◕‿◕)", "(｡•̀ᴗ-)✧", "(╯°□°)╯︵ ┻━┻", "┬─┬ノ( º _ ºノ)", "¯\\_(ツ)_/¯", "(ಠ_ಠ)", "(•_•)", "( •_•)>⌐■-■", "(⌐■_■)", "ʕ•ᴥ•ʔ", "(づ｡◕‿‿◕｡)づ", "(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧", "ヽ(°〇°)ﾉ", "(T_T)", "(^_^;)", "(≧▽≦)", "(￣▽￣)ノ", "(*^▽^*)", "o(〃＾▽＾〃)o", "(¬‿¬)"]);

export const EMOJI_GROUP_IDS = Object.freeze({
    "Smileys & Emotion": "smileys",
    "People & Body": "people",
    "Animals & Nature": "nature",
    "Food & Drink": "food",
    "Travel & Places": "travel",
    "Activities": "activities",
    "Objects": "objects",
    "Symbols": "symbols",
    "Flags": "flags",
});
