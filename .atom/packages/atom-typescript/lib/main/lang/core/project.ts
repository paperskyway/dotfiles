

import path = require('path');
import fs = require('fs');
import os = require('os');

export import languageServiceHost = require('./languageServiceHost2');
import tsconfig = require('../../tsconfig/tsconfig');
import utils = require('../utils');
import * as transformerRegistry from "../transformers/transformerRegistry";

/**
 * Wraps up `langaugeService` `languageServiceHost` and `projectFile` in a single package
 */
export class Project {
    public languageServiceHost: languageServiceHost.LanguageServiceHost;
    public languageService: ts.LanguageService;

    constructor(public projectFile: tsconfig.TypeScriptProjectFileDetails) {
        this.languageServiceHost = new languageServiceHost.LanguageServiceHost(projectFile);
        var transformerRegexes = transformerRegistry.getRegexes();

        // Add all the files
        projectFile.project.files.forEach((file) => {
            if (tsconfig.endsWith(file, '.tst.ts')) {
                // initially add without transform sections.
                var rawContent = fs.readFileSync(tsconfig.removeExt(file), 'utf-8');

                var withoutTransform = rawContent;
                transformerRegexes.forEach(transformer => {
                    withoutTransform = withoutTransform.replace(transformer, '');;
                });

                this.languageServiceHost.addScript(file, withoutTransform);
                // TODO: update with transform sections
            }
            else {
                this.languageServiceHost.addScript(file);
            }
        });


        this.languageService = ts.createLanguageService(this.languageServiceHost, ts.createDocumentRegistry());
    }

    /** all files except lib.d.ts  */
    public getProjectSourceFiles(): ts.SourceFile[] {
        var libFile = languageServiceHost.getDefaultLibFilePath(this.projectFile.project.compilerOptions);
        var files
            = this.languageService.getProgram().getSourceFiles().filter(x=> x.fileName !== libFile);
        return files;
    }

    public includesSourceFile(fileName: string) {
        return (this.getProjectSourceFiles().filter((f) => f.fileName === fileName).length === 1);
    }
}
