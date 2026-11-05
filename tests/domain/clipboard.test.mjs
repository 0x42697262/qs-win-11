import { test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { emojiGroups, parseCliphistList, searchEmoji } from "../../src/domain/input/clipboard.mjs";

test("cliphist list parses ids, previews and images", () => {
    const entries = parseCliphistList("12\thello world\n11\t[[ binary data 20 KiB png 64x64 ]]\n10\t[[ binary data 3 KiB application/pdf ]]\nbroken\n", 10);
    assert.deepEqual(entries.map(entry => [entry.id, entry.isImage]), [["12", false], ["11", true], ["10", false]]);
    assert.equal(entries[0].line, "12\thello world");
    assert.equal(parseCliphistList("1\ta\n2\tb\n", 1).length, 1);
});

test("bundled emoji load and search ranks prefix matches first", () => {
    const groups = emojiGroups(JSON.parse(readFileSync(new URL("../../assets/emoji/emoji.json", import.meta.url), "utf8")));
    assert.ok(groups.length >= 8);
    const results = searchEmoji(groups, "heart", 5);
    assert.ok(results.length === 5);
    assert.ok(results[0].name.startsWith("heart") || results[0].name.includes(" heart"), results[0].name);
    assert.deepEqual(searchEmoji(groups, "  ", 5), []);
    assert.ok(searchEmoji(groups, "face joy", 3).some(emoji => emoji.char === "😂"));
    assert.deepEqual(emojiGroups(null), []);
});
