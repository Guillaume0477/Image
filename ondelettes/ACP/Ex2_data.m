% Serge Mazauric
% Mercredi 31 janvier 2018
% CPE Lyon - 4ETI
% Analyse en Composantes Principales
% Exercice 2 : habitudes alimentaires (données)


data=  [68	76	127	60	72	68	84	68	82;
        2	4	3	3	2	3	2	2	4;
        81	74	41	81	101	102	111	68	70;
        36	34	31	37	35	40	42	44	24;
        64	115	172	82	60	76	83	57	237;
        89	53	69	84	64	33	30	38	57;
        25	93	87	13	66	6	3	14	45;
        6	12	20	4	4	8	8	7	22;
        7	3	1	12	10	6	4	12	1;
        24	33	25	21	28	23	23	13	20;
        58	38	24	41	41	26	32	51	18;
        84	90	80	136	87	14	14	9	13;
        85	91	84	135	89	134	187	159	64;
        6	7	2	3	8	5	11	6	1;
        12	18	13	13	10	6	3	10	8;
        17	15	11	11	14	14	14	14	12];

tab_1={ 'RFA' 3;
        'France' 6;
        'Italie' 6;
        'Pays Bas' 8;
        'Belg. Lux.' 10;	
        'Russie' 6;
        'Irlande' 7;
        'Danemark' 8;	
        'Grèce' 5};  

tab_2={ 'Céréales' 8;
        'Riz' 3;
        'Pommes de terre' 14;
        'Sucre blanc' 11;
        'Légumes' 7;
        'Fruits' 6;
        'Vin' 3;
        'Huiles végétales' 16;
        'Margarine' 9;
        'Viande bov.' 11;
        'Viande porc.' 12;
        'Volailles' 9;
        'Lait et dériv.' 14;
        'Beurre' 6;
        'Fromages' 8;
        'Oeufs' 5 }; 