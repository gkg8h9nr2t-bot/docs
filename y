=*/
void
optionResetOpt( tOptions* pOpts, tOptDesc* pOD )
{
    static ag_bool reset_active = AG_FALSE;

    tOptState opt_state = OPTSTATE_INITIALIZER(DEFINED);
    char const * pzArg = pOD->optArg.argString;
    tSuccess     succ;

    if (reset_active)
        return;

    if (  (! HAS_originalOptArgArray(pOpts))
       || (pOpts->originalOptArgCookie == NULL)) {
        fputs(zResetNotConfig, stderr);
        _exit(EX_SOFTWARE);
    }

    if ((pzArg == NULL) || (*pzArg == NUL)) {
        fputs(zNoResetArg, stderr);
        pOpts->pUsageProc(pOpts, EXIT_FAILURE);
        /* NOTREACHED */
        assert(0 == 1);
    }

    reset_active = AG_TRUE;

    if (pzArg[1] == NUL) {
        if (*pzArg == '*') {
            optionResetEverything(pOpts);
            reset_active = AG_FALSE;
            return;
        }

        succ = shortOptionFind(pOpts, (tAoUC)*pzArg, &opt_state);
        if (! SUCCESSFUL(succ)) {
            fprintf(stderr, zIllOptChr, pOpts->pzProgPath, *pzArg);
            pOpts->pUsageProc(pOpts, EXIT_FAILURE);
            /* NOTREACHED */
            assert(0 == 1);
        }
    } else {
        succ = longOptionFind(pOpts, (char *)pzArg, &opt_state);
        if (! SUCCESSFUL(succ)) {
            fprintf(stderr, zIllOptStr, pOpts->pzProgPath, pzArg);
            pOpts->pUsageProc(pOpts, EXIT_FAILURE);
            /* NOTREACHED */
            assert(0 == 1);
        }
    }
