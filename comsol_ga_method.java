// Paste this code into a COMSOL App Builder Method.
// Edit only the USER SETTINGS block before running.

// ===================== USER SETTINGS =====================
String studyTag = "std1";
String evalTag = "gev1";
String objectiveExpr = "opti_final";

// Solver sequences whose solution data will be cleared after each evaluation.
// Check Study > Solver Configurations in your model. Common tags are "sol1", "sol2".
String[] solverTagsToClear = new String[] {
    "sol1"
};

// Parameter names to optimize. Replace these with your COMSOL parameter names.
String[] paramNames = new String[] {
    "p1",
    "p2",
    "p3"
};

// Units appended when setting parameters. Use "" for dimensionless variables.
String[] units = new String[] {
    "[um]",
    "[um]",
    "[deg]"
};

// Lower and upper bounds in the numerical values corresponding to units above.
double[] lower = new double[] {
    0.10,
    0.10,
    -30.0
};

double[] upper = new double[] {
    2.00,
    2.00,
    30.0
};

// Good initial value. Put your current best COMSOL parameters here.
double[] x0 = new double[] {
    0.80,
    0.80,
    0.0
};

// GA controls.
int popSize = 32;
int maxGen = 60;
int eliteCount = 2;
int tournamentSize = 3;
double crossoverRate = 0.90;
double mutationRate = 0.20;
double mutationScale = 0.08;       // Fraction of each variable range.
double targetFitness = 1.0e-4;
int maxStallGen = 18;
double minImprovement = 1.0e-7;
long randomSeed = 20260710L;

// Memory controls. Keep these true for long GA runs.
boolean clearSolutionsAfterEachEval = true;
boolean clearPlotDataAfterEachEval = true;
int gcEveryNEvals = 5;
// =================== END USER SETTINGS ===================

int nvar = paramNames.length;
java.util.Random rng = new java.util.Random(randomSeed);
int evalCount = 0;

if (units.length != nvar || lower.length != nvar || upper.length != nvar || x0.length != nvar) {
    throw new RuntimeException("GA array length mismatch. Check paramNames, units, lower, upper, and x0.");
}
if (eliteCount < 1) {
    eliteCount = 1;
}
if (eliteCount >= popSize) {
    eliteCount = popSize - 1;
}

try {
    model.result().numerical().create(evalTag, "EvalGlobal");
} catch (Exception alreadyExists) {
    // Reuse existing global evaluation node.
}
model.result().numerical(evalTag).set("expr", new String[] {objectiveExpr});

double[][] pop = new double[popSize][nvar];
double[] fit = new double[popSize];
double[][] newPop = new double[popSize][nvar];
int[] order = new int[popSize];

for (int j = 0; j < nvar; j++) {
    if (upper[j] <= lower[j]) {
        throw new RuntimeException("Upper bound must be larger than lower bound for " + paramNames[j]);
    }
    if (x0[j] < lower[j]) {
        x0[j] = lower[j];
    }
    if (x0[j] > upper[j]) {
        x0[j] = upper[j];
    }
    pop[0][j] = x0[j];
}

for (int i = 1; i < popSize; i++) {
    for (int j = 0; j < nvar; j++) {
        double width = upper[j] - lower[j];
        pop[i][j] = lower[j] + rng.nextDouble()*width;
    }
}

double globalBestFit = 1.0e300;
double[] globalBestX = new double[nvar];
int stall = 0;

for (int gen = 0; gen < maxGen; gen++) {

    for (int i = 0; i < popSize; i++) {
        for (int j = 0; j < nvar; j++) {
            model.param().set(paramNames[j], java.lang.Double.toString(pop[i][j]) + units[j]);
        }

        double value = 1.0e300;
        try {
            model.study(studyTag).run();
            double[][] realValue = model.result().numerical(evalTag).getReal();
            value = realValue[0][0];
            if (java.lang.Double.isNaN(value) || java.lang.Double.isInfinite(value)) {
                value = 1.0e300;
            }
        } catch (Exception solveFailed) {
            value = 1.0e300;
        }
        fit[i] = value;

        if (clearPlotDataAfterEachEval) {
            try {
                model.result().clearStoredPlotData();
            } catch (Exception plotClearFailed) {
                // Some COMSOL versions or result states may not have stored plot data.
            }
        }

        if (clearSolutionsAfterEachEval) {
            for (int s = 0; s < solverTagsToClear.length; s++) {
                try {
                    model.sol(solverTagsToClear[s]).clearSolutionData();
                } catch (Exception solClearFailed) {
                    // If the solver tag is wrong, edit solverTagsToClear in USER SETTINGS.
                }
            }
        }

        evalCount++;
        if (gcEveryNEvals > 0 && evalCount%gcEveryNEvals == 0) {
            java.lang.System.gc();
        }
    }

    for (int i = 0; i < popSize; i++) {
        order[i] = i;
    }
    for (int a = 0; a < popSize - 1; a++) {
        int best = a;
        for (int b = a + 1; b < popSize; b++) {
            if (fit[order[b]] < fit[order[best]]) {
                best = b;
            }
        }
        int tmp = order[a];
        order[a] = order[best];
        order[best] = tmp;
    }

    int bestIndex = order[0];
    if (fit[bestIndex] < globalBestFit - minImprovement) {
        globalBestFit = fit[bestIndex];
        for (int j = 0; j < nvar; j++) {
            globalBestX[j] = pop[bestIndex][j];
        }
        stall = 0;
    } else {
        stall++;
    }

    java.lang.System.out.println("GA gen " + gen + ", best=" + fit[bestIndex] + ", globalBest=" + globalBestFit);

    if (globalBestFit <= targetFitness || stall >= maxStallGen) {
        break;
    }

    for (int e = 0; e < eliteCount; e++) {
        int idx = order[e];
        for (int j = 0; j < nvar; j++) {
            newPop[e][j] = pop[idx][j];
        }
    }

    for (int i = eliteCount; i < popSize; i++) {
        int p1 = -1;
        int p2 = -1;

        for (int t = 0; t < tournamentSize; t++) {
            int cand = (int)java.lang.Math.floor(rng.nextDouble()*popSize);
            if (p1 < 0 || fit[cand] < fit[p1]) {
                p1 = cand;
            }
        }
        for (int t = 0; t < tournamentSize; t++) {
            int cand = (int)java.lang.Math.floor(rng.nextDouble()*popSize);
            if (p2 < 0 || fit[cand] < fit[p2]) {
                p2 = cand;
            }
        }

        for (int j = 0; j < nvar; j++) {
            double child;
            if (rng.nextDouble() < crossoverRate) {
                double alpha = rng.nextDouble();
                child = alpha*pop[p1][j] + (1.0 - alpha)*pop[p2][j];
            } else {
                child = pop[p1][j];
            }

            if (rng.nextDouble() < mutationRate) {
                double width = upper[j] - lower[j];
                child += rng.nextGaussian()*mutationScale*width;
            }

            if (child < lower[j]) {
                child = lower[j];
            }
            if (child > upper[j]) {
                child = upper[j];
            }
            newPop[i][j] = child;
        }
    }

    double[][] swap = pop;
    pop = newPop;
    newPop = swap;
}

for (int j = 0; j < nvar; j++) {
    model.param().set(paramNames[j], java.lang.Double.toString(globalBestX[j]) + units[j]);
}
model.param().set("ga_best_obj", java.lang.Double.toString(globalBestFit));

try {
    model.study(studyTag).run();
    if (clearPlotDataAfterEachEval) {
        model.result().clearStoredPlotData();
    }
} catch (Exception finalRunFailed) {
    java.lang.System.out.println("Final run failed after setting GA best parameters.");
}

java.lang.System.out.println("GA finished. Best objective = " + globalBestFit);
for (int j = 0; j < nvar; j++) {
    java.lang.System.out.println(paramNames[j] + " = " + globalBestX[j] + units[j]);
}
