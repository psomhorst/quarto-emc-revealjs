# quarto-emc-revealjs

Reveal.js-sjabloon voor presentaties in Erasmus MC-huisstijl.

- [Gebruik](#gebruik)
- [Wat de extensie meebrengt](#wat-de-extensie-meebrengt)
- [Achtergronden](#achtergronden)
- [Opbouw en fragmenten](#opbouw-en-fragmenten)
- [Beeld plaatsen](#beeld-plaatsen)
- [Indeling](#indeling)
- [Opdrachten en callouts](#opdrachten-en-callouts)
- [Literatuurverwijzingen](#literatuurverwijzingen)
- [Datumopmaak](#datumopmaak)
- [Aanpassen](#aanpassen)

## Gebruik

```bash
quarto use template psomhorst/quarto-emc-revealjs
```

Of kopieer lokaal de map `_extensions/` en `template.qmd` naar een nieuwe map.

In de presentatie zelf is dit genoeg — er is geen `_quarto.yml` nodig:

```yaml
---
title: Titel van de presentatie
subtitle: Ondertitel
author: Peter Somhorst
date: today
format: emc-revealjs
---
```

Alle overige instellingen (1920×1080, incrementeel, logo, lettertypen,
inhoudsopgave, `embed-resources`) zitten in de extensie.

## Wat de extensie meebrengt

| Onderdeel | Bestand |
| --- | --- |
| Huisstijl, lettertypen, `.no-logo` | `emc-revealjs.scss` |
| Logo rechtsonder | `logo-emc.png` |
| Opdrachten en callouts | `assignment.lua` + `assignment.css` |
| `. . .`-pauzes verbergen buiten reveal.js | `hide-pauses.lua` |
| Volledige literatuurverwijzing in aside/voetnoot | `fullcite.lua` |
| `height`-attribuut van figuren strippen | `strip-image-height.lua` |

## Achtergronden

Attributen achter de `##`-kop. De kop mag leeg blijven voor een dia
zonder titel.

**Beeldvullend, hele afbeelding passend in beeld**

```markdown
## {background-image="media/foto.jpg" background-size="contain" .no-logo}
```

**Beeldvullend, scherm vullen en bijsnijden**

```markdown
## {background-image="media/foto.jpg" background-size="cover" .no-logo}
```

`background-size` neemt gewone CSS-waarden. Alleen `contain` en `cover`
zijn zinvol; **`fit` bestaat niet** en valt stil terug op `cover`.

`contain` laat randen over. Kleur die met `background-color`:

```markdown
## {background-image="media/foto.jpg" background-size="contain" background-color="#111F6F" .no-logo}
```

**Foto dimmen zodat tekst leesbaar blijft**

```markdown
## Onze afdeling {background-image="media/zaal.jpg" background-size="cover" background-opacity="0.3"}

Deze tekst staat leesbaar over de foto heen.
```

Prettiger dan schaduwen onder de tekst leggen.

**Uitsnede kiezen** — standaard staat de afbeelding gecentreerd;
`background-position` neemt CSS-waarden zoals `top`, `center`, `50% 20%`.

```markdown
## {background-image="media/groep.jpg" background-size="cover" background-position="top"}
```

**Effen kleur of verloop**

```markdown
## {background-color="#111F6F"}

## {background-gradient="linear-gradient(to bottom, #111F6F, #ffffff)"}
```

Op een donkere achtergrond zet reveal.js zelf `has-dark-background` en
draait de tekstkleur om; daar hoeft niets voor te gebeuren.

**Video**

```markdown
## {background-video="media/clip.mp4" background-video-loop="true" background-video-muted="true" .no-logo}
```

**Logo verbergen** — geef de dia `.no-logo`. Dat is geen standaard
Quarto-klasse maar een regel uit `emc-revealjs.scss`. Nodig omdat Quarto
het logo met JavaScript uit de secties haalt en aan `.reveal` hangt, zodat
een gewone nakomeling-selector er niet bij kan:

```scss
.reveal:has(section.present.no-logo) .slide-logo { display: none; }
```

## Opbouw en fragmenten

**Pauze** — een regel met `. . .` splitst de dia op:

```markdown
## Voorstellen

Peter Somhorst

. . .

Verschijnt pas bij de volgende klik.
```

`incremental: true` staat aan, dus lijsten lopen vanzelf stap voor stap
door. Uitzetten per dia:

```markdown
::: {.nonincremental}
- alles tegelijk
- zichtbaar
:::
```

**Fragmenten met effect en volgorde**

```markdown
::: {.fragment .fade-in}
Verschijnt
:::

::: {.fragment .highlight-red fragment-index=2}
Wordt rood, als tweede
:::
```

Bruikbare klassen: `fade-in`, `fade-out`, `fade-up`, `grow`, `shrink`,
`highlight-red`, `highlight-blue`, `semi-fade-out`.

**Sprekersnotities** — zichtbaar in de presenter view (druk op `S`):

```markdown
::: {.notes}
Niet vergeten: aanmelden voor de introductieweek.
:::
```

**Tekstgrootte**

```markdown
## Veel tekst {.smaller}      <!-- 0.7x, ingebouwd in Quarto -->
## Weinig tekst {.larger}     <!-- 1.3x, uit deze extensie -->
## Heel veel tekst {.scrollable}
```

Quarto kent alleen `.smaller`; `.larger` is de tegenhanger uit
`emc-revealjs.scss`. Beide laten de koppen even groot en schalen alleen
de inhoud. De factor staat bovenin het scss-bestand:

```scss
$presentation-font-larger: 1.3 !default;
```

Voor een enkele regel zo groot mogelijk in beeld:

```markdown
::: {.r-fit-text}
Kort en enorm
:::
```

En voor een eenmalige uitschieter:

```markdown
[Deze zin is 2em]{style="font-size: 2em"}
```

## Beeld plaatsen

**Vanzelf schalend** — staat een afbeelding alleen op een dia, dan geeft
Quarto hem `.r-stretch` en vult hij de vrije hoogte:

```markdown
## Het gebouw

![](media/gebouw.jpg)
```

**Op een vaste plek**

```markdown
![](media/foto.png){.absolute top=100 left=200 width="300"}
```

**Op breedte**

```markdown
![](media/foto.png){width=60%}
```

## Indeling

```markdown
:::: {.columns}
::: {.column width="40%"}
Links
:::
::: {.column width="60%"}
Rechts
:::
::::
```

**Code met oplopende markering** — de `|` scheidt de stappen:

````markdown
``` {.python code-line-numbers="1|2"}
a = 1
b = 2
```
````

## Opdrachten en callouts

Uit `assignment.lua`. De extensie declareert zelf de bijbehorende
`crossref`-typen, dus dit werkt zonder extra configuratie.

```markdown
::: {.question label="q1"}
Wat is de drijvende druk?
:::

::: {.answer}
Plateaudruk min PEEP.
:::

::: {.context title="Achtergrond"}
Uitleg vooraf.
:::

::: {.reading}
Lees hoofdstuk 3.
:::

::: {.box label="b1" title="Kernpunt"}
Inhoud van de box.
:::

::: {.lecturer-comments}
Alleen zichtbaar in het docentprofiel.
:::
```

`.box` heeft een `label` nodig. Bij `.question` mag het weg: die valt dan
terug op `ass-` en wordt gewoon meegenummerd. Twee profielen sturen de
zichtbaarheid:

```bash
quarto render presentatie.qmd --profile clean      # zonder antwoorden
quarto render presentatie.qmd --profile lecturer   # met docentopmerkingen
```

## Literatuurverwijzingen

`fullcite.lua` vervangt een aside of voetnoot die *alleen* uit één citatie
bestaat door de volledige literatuurvermelding:

```markdown
---
bibliography: refs.bib
---

## Drijvende druk

Belangrijke studie.

::: aside
[@amato2015]
:::
```

wordt

> Amato, Marcelo B. P., en Maureen O. Meade. 2015. ‘Driving Pressure and
> Survival in the Acute Respiratory Distress Syndrome’. *New England
> Journal of Medicine* 372: 747-55.

Gemengde inhoud (`Zie [@amato2015] voor details`) blijft ongemoeid, dus
gewone citaties werken nog steeds. Door `lang: nl` wordt de vermelding in
het Nederlands opgemaakt.

## Datumopmaak

`date-format` gebruikt **Moment.js**-tokens, niet die van date-fns. Dat is
de valkuil: kleine `d` is de dag van de *week* en `y` bestaat niet — die
komt letterlijk in de uitvoer terecht.

| Wat | Token | Uitvoer |
| --- | --- | --- |
| Dag van de maand | `D` / `DD` | `1` / `01` |
| Maandnaam | `MMM` / `MMMM` | `sep` / `september` |
| Maandnummer | `M` / `MM` | `9` / `09` |
| Jaar | `YYYY` / `YY` | `2026` / `26` |
| Dag van de week | `ddd` / `dddd` | `di` / `dinsdag` |

De standaard hier is `D MMMM YYYY` → `1 september 2026`. Er zijn ook
kortingen: `date-format: long`, `medium`, `short`, `iso`.

## Aanpassen

Kleuren en lettertypen staan bovenin `emc-revealjs.scss`:

```scss
/*-- scss:defaults --*/
$presentation-heading-font: Merriweather Sans;
$font-family-sans-serif: Montserrat;
$presentation-heading-color: #111F6F;
$presentation-font-size-root: 44px;
```

De deck-instellingen staan in `_extensions/psomhorst/emc/_extension.yml`.
Beide gelden meteen voor elke presentatie die de extensie gebruikt.
Een losse instelling overschrijven doe je gewoon in de presentatie zelf:

```yaml
format:
  emc-revealjs:
    incremental: false
    toc: false
```
