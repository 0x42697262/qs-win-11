export const IdleStage = Object.freeze({ Dim: "dim", Lock: "lock", ScreenOff: "screenOff", Suspend: "suspend" });

/** @typedef {{ stage: string, seconds: number }} IdleStep */

/**
 * @param {{ dimSeconds: number, lockSeconds: number, screenOffSeconds: number, suspendSeconds: number }} idle
 * @returns {IdleStep[]}
 */
export function idleSteps(idle) {
    return [
        { stage: IdleStage.Dim, seconds: idle.dimSeconds },
        { stage: IdleStage.Lock, seconds: idle.lockSeconds },
        { stage: IdleStage.ScreenOff, seconds: idle.screenOffSeconds },
        { stage: IdleStage.Suspend, seconds: idle.suspendSeconds },
    ].filter((step) => step.seconds > 0).sort((left, right) => left.seconds - right.seconds);
}
