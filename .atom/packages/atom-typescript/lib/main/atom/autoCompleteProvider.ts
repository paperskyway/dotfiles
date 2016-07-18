/// <reference path='../../globals'/>

// more: https://github.com/atom-community/autocomplete-plus/wiki/Provider-API

///ts:import=parent
import parent = require('../../worker/parent'); ///ts:import:generated
///ts:import=atomConfig
import atomConfig = require('./atomConfig'); ///ts:import:generated
import fs = require('fs');
///ts:import=atomUtils
import atomUtils = require('./atomUtils'); ///ts:import:generated
import escape = require('escape-html');

var fuzzaldrin = require('fuzzaldrin');
var CSON = require("season");

declare module autocompleteplus {
    /** What gets passed into the handler */
    export interface RequestOptions {
        editor: AtomCore.IEditor;
        bufferPosition: TextBuffer.IPoint; // the position of the cursor
        prefix: string;
        scopeDescriptor: { scopes: string[] };
    }

    /** The suggestion */
    export interface Suggestion {
        //Either text or snippet is required

        text?: string;
        snippet?: string;

        replacementPrefix?: string;

        rightLabel?: string;
        rightLabelHTML?: string;
        leftLabel?: string;
        type: string;
        description?: string;

        atomTS_IsReference?: {
            relativePath: string
        };
        atomTS_IsImport?: {
            relativePath: string
        };
        atomTS_IsES6Import?: {
            relativePath: string
        };
    }

    /** What the provider needs to implement */
    export interface Provider {
        inclusionPriority?: number;
        excludeLowerPriority?: boolean;
        suggestionPriority?: number;
        selector: string;
        disableForSelector?: string;
        getSuggestions: (options: RequestOptions) => Promise<Suggestion[]>;
        onDidInsertSuggestion?: (args: { editor: AtomCore.IEditor; triggerPosition: TextBuffer.IPoint; suggestion: Suggestion }) => any;
    }
}

var explicitlyTriggered = false;
export function triggerAutocompletePlus() {
    atom.commands.dispatch(
        atom.views.getView(atom.workspace.getActiveTextEditor()),
        'autocomplete-plus:activate');
    explicitlyTriggered = true;
}

// the structure stored in the CSON snippet file
interface SnippetDescriptor {
    prefix: string;
    body: string;
}
interface SnippetsContianer {
    [name: string]: SnippetDescriptor;
}

export var provider: autocompleteplus.Provider = {
    selector: '.source.ts, .source.tsx',
    inclusionPriority: 3,
    suggestionPriority: 3,
    excludeLowerPriority: false,
    getSuggestions: (options: autocompleteplus.RequestOptions): Promise<autocompleteplus.Suggestion[]>=> {

        var filePath = options.editor.getPath();

        // We refuse to work on files that are not on disk.
        if (!filePath) return Promise.resolve([]);
        if (!fs.existsSync(filePath)) return Promise.resolve([]);

        // If we are looking at reference or require path support file system completions
        var pathMatchers = ['reference.path.string.quoted', 'require.path.string.quoted', 'es6import.path.string.quoted'];
        var lastScope = options.scopeDescriptor.scopes[options.scopeDescriptor.scopes.length - 1];

        // For file path completions
        if (pathMatchers.some(p=> lastScope === p)) {
            return parent.getRelativePathsInProject({ filePath, prefix: options.prefix, includeExternalModules: lastScope !== 'reference.path.string.quoted' })
                .then((resp) => {
                return resp.files.map(file => {
                    var relativePath = file.relativePath;

                    /** Optionally customize this in future */
                    var suggestionText = relativePath;

                    var suggestion: autocompleteplus.Suggestion = {
                        text: suggestionText,
                        replacementPrefix: resp.endsInPunctuation ? '' : options.prefix.trim(),
                        rightLabelHTML: '<span>' + file.name + '</span>',
                        type: 'path'
                    };

                    if (lastScope == 'reference.path.string.quoted') {
                        suggestion.atomTS_IsReference = {
                            relativePath: relativePath
                        };
                    }

                    if (lastScope == 'require.path.string.quoted') {
                        suggestion.atomTS_IsImport = {
                            relativePath: relativePath
                        };
                    }

                    if (lastScope == 'es6import.path.string.quoted') {
                        suggestion.atomTS_IsES6Import = {
                            relativePath: relativePath
                        };
                    }

                    return suggestion;
                });
            });
        }
        else {

            // if explicitly triggered reset the explicit nature
            if (explicitlyTriggered) {
                explicitlyTriggered = false;
            }
            else { // else in special cases for automatic triggering refuse to provide completions
                const prefix = options.prefix.trim()

                if (prefix === '' || prefix === ';') {
                    return Promise.resolve([]);
                }
            }

            var position = atomUtils.getEditorPositionForBufferPosition(options.editor, options.bufferPosition);

            var promisedSuggestions: Promise<autocompleteplus.Suggestion[]>
                = parent.getCompletionsAtPosition({
                    filePath: filePath,
                    position: position,
                    prefix: options.prefix,
                })
                    .then((resp) => {

                    var completionList = resp.completions;
                    var suggestions = completionList.map((c): autocompleteplus.Suggestion => {

                        if (c.snippet) // currently only function completions are snippet
                        {
                            return {
                                snippet: c.snippet,
                                replacementPrefix: '',
                                rightLabel: 'signature',
                                type: 'snippet',
                            };
                        }
                        else {
                            var prefix = options.prefix;
                            // If the completion is $foo
                            // The prefix from acp is actually only `foo`
                            // But the var is $foo
                            // => so we would potentially end up replacing $foo with $$foo
                            // Fix that:
                            if (c.name && c.name.startsWith('$')) {
                                prefix = "$" + prefix;
                            }

                            return {
                                text: c.name,
                                replacementPrefix: resp.endsInPunctuation ? '' : prefix.trim(),
                                rightLabel: c.display,
                                leftLabel: c.kind,
                                type: atomUtils.kindToType(c.kind),
                                description: c.comment,
                            };
                        }
                    });

                    return suggestions;
                });

            return promisedSuggestions;
        }
    },
    onDidInsertSuggestion: (options) => {
        if (options.suggestion.atomTS_IsReference
            || options.suggestion.atomTS_IsImport
            || options.suggestion.atomTS_IsES6Import) {

            // '' implies we will preserve their quote character
            var quote = (/["']/.exec(atomConfig.preferredQuoteCharacter) || [''])[0];

            if (options.suggestion.atomTS_IsReference) {
                options.editor.moveToBeginningOfLine();
                options.editor.selectToEndOfLine();
                options.editor.replaceSelectedText(null, function() { return '/// <reference path="' + options.suggestion.atomTS_IsReference.relativePath + '.ts"/>'; });
            }
            if (options.suggestion.atomTS_IsImport) {
                options.editor.moveToBeginningOfLine();
                options.editor.selectToEndOfLine();
                var groups = /^(\s*)import\s*(\w*)\s*=\s*require\s*\(\s*(["'])/.exec(options.editor.getSelectedText());
                var leadingWhiteSpace = groups[1];
                var alias = groups[2];

                // Use the option if they have a preferred. Otherwise preserve
                quote = quote || groups[3];

                options.editor.replaceSelectedText(null, function() { return `${leadingWhiteSpace}import ${alias} = require(${quote}${options.suggestion.atomTS_IsImport.relativePath}${quote});`; });
            }
            if (options.suggestion.atomTS_IsES6Import) {
                var {row} = options.editor.getCursorBufferPosition();
                var originalText = (<any>options.editor).lineTextForBufferRow(row);
                var groups = /(.*)from\s*(["'])/.exec(originalText);
                var beforeFrom = groups[1];

                // Use the option if they have a preferred. Otherwise preserve
                quote = quote || groups[2];

                var newTextAfterFrom = `from ${quote}${options.suggestion.atomTS_IsES6Import.relativePath}${quote};`;
                options.editor.setTextInBufferRange([[row, beforeFrom.length], [row, originalText.length]], newTextAfterFrom)

            }
            options.editor.moveToEndOfLine();
        }
    }
}
