pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/search/calculator.mjs" as Calculator
import "../domain/search/searchEntries.mjs" as SearchEntries
import "../domain/catalog/settingsSchema.mjs" as Schema

Singleton {
    function entries(query: string): list<var> {
        const tuning = Settings.values.tuning;
        const calculation = Settings.values.startMenu.searchCalculator ? Calculator.calculate(query, tuning.calculatorDigits) : null;
        const settings = Settings.values.startMenu.searchSettings ? SearchEntries.rankSettings(Schema.SETTING_DEFINITIONS, query, tuning.searchSettingsLimit, tuning.searchSettingsMinLength) : [];
        return SearchEntries.buildSearchEntries(calculation, query.trim() === "" ? [] : Apps.search(query), settings);
    }

    function activate(entry: var): void {
        if (!entry) {
            return;
        }
        if (entry.kind === SearchEntries.SearchEntryKind.Calculation) {
            Quickshell.clipboardText = entry.title;
            ShellState.close();
        } else if (entry.kind === SearchEntries.SearchEntryKind.Setting) {
            SettingsWindow.showSetting(entry.id);
        } else {
            ShellState.close();
            Apps.launch(entry.id);
        }
    }
}
