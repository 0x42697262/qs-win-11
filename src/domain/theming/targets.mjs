import { APP_THEME_TARGETS, TEMPLATE_EXTENSION } from "../catalog/appThemes.mjs";

/** @typedef {import("../catalog/appThemes.mjs").AppThemeTarget} AppThemeTarget */
/** @typedef {{ id: string, templatePath: string, outputPath: string }} RenderJob */

const CUSTOM_OUTPUT_DIRECTORY = "custom";
const PATH_SEPARATOR = "/";

/**
 * @param {readonly string[]} enabledIds
 * @param {string} bundledDirectory
 * @param {readonly string[]} userTemplates
 * @param {string} userDirectory
 * @param {string} outputDirectory
 * @returns {RenderJob[]}
 */
export function planRenderJobs(enabledIds, bundledDirectory, userTemplates, userDirectory, outputDirectory) {
    const userNames = userTemplates.map(path => path.slice(path.lastIndexOf(PATH_SEPARATOR) + 1)).filter(name => name.endsWith(TEMPLATE_EXTENSION));
    /** @type {RenderJob[]} */
    const jobs = APP_THEME_TARGETS
        .filter(target => enabledIds.indexOf(target.id) >= 0)
        .map(target => {
            const fileName = `${target.template}${TEMPLATE_EXTENSION}`;
            const fromUser = userNames.indexOf(fileName) >= 0;
            return { id: target.id, templatePath: `${fromUser ? userDirectory : bundledDirectory}/${fileName}`, outputPath: `${outputDirectory}/${target.output}` };
        });
    const builtIn = APP_THEME_TARGETS.map(target => `${target.template}${TEMPLATE_EXTENSION}`);
    userNames.filter(name => builtIn.indexOf(name) < 0).forEach(name => {
        const outputName = name.slice(0, name.length - TEMPLATE_EXTENSION.length);
        jobs.push({ id: outputName, templatePath: `${userDirectory}/${name}`, outputPath: `${outputDirectory}/${CUSTOM_OUTPUT_DIRECTORY}/${outputName}` });
    });
    return jobs;
}
