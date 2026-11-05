import { test } from "node:test";
import assert from "node:assert/strict";
import { formatBytes, netRate, parseDiskUsage, parseGpuUsage, parseNetDev, pushHistory } from "../../src/domain/system/stats.mjs";

test("network totals skip loopback", () => {
    const text = "Inter-|   Receive\n face |bytes packets\n    lo: 100 1 0 0 0 0 0 0 100 1 0 0 0 0 0 0\n  eth0: 2000 5 0 0 0 0 0 0 500 3 0 0 0 0 0 0\n wlan0: 1000 2 0 0 0 0 0 0 250 1 0 0 0 0 0 0\n";
    assert.deepEqual(parseNetDev(text), { rx: 3000, tx: 750 });
    assert.deepEqual(netRate({ rx: 1000, tx: 100 }, { rx: 3000, tx: 500 }, 2), { rx: 1000, tx: 200 });
    assert.deepEqual(netRate({ rx: 1000, tx: 100 }, { rx: 0, tx: 0 }, 2), { rx: 0, tx: 0 });
});

test("disk usage from df -P -B1", () => {
    assert.deepEqual(parseDiskUsage("Filesystem 1-blocks Used Available Capacity Mounted on\n/dev/sda1 1000 400 600 40% /\n"), { used: 400, total: 1000 });
});

test("gpu usage from amd or nvidia lines", () => {
    assert.equal(parseGpuUsage("amd 37\n"), 0.37);
    assert.equal(parseGpuUsage("nvidia 55, 1024, 8192\n"), 0.55);
    assert.equal(parseGpuUsage(""), null);
});

test("bytes and history", () => {
    const suffixes = ["B", "KB", "MB", "GB"];
    assert.equal(formatBytes(512, suffixes), "512 B");
    assert.equal(formatBytes(1536, suffixes), "1.5 KB");
    assert.equal(formatBytes(5 * 1024 ** 4, suffixes), "5120.0 GB");
    assert.deepEqual(pushHistory([1, 2, 3], 4, 3), [2, 3, 4]);
});

test("cava config and frames", async () => {
    const { cavaConfig, parseCavaFrame } = await import("../../src/domain/media/visualizer.mjs");
    const config = cavaConfig(16, 30, 100);
    assert.match(config, /bars = 16/);
    assert.match(config, /bar_delimiter = 59/);
    assert.deepEqual(parseCavaFrame("0;50;100;150;\n", 100), [0, 0.5, 1, 1]);
});
