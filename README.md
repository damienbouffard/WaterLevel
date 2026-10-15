# Swiss lake water levels in the dry summer of 2026

Analysis of the record low lake levels in Switzerland in summer 2026, using open data from the Federal Office
for the Environment (FOEN), MeteoSwiss, the CAMELS-CH catchment database, the Simstrat lake model and the SWOT
satellite (both via [Alplakes](https://www.alplakes.eawag.ch)).

**Read the report:** [lake_levels_2026_report.pdf](lake_levels_2026_report.pdf)
(a version with larger figure fonts is in [lake_levels_2026_report_large.pdf](lake_levels_2026_report_large.pdf);
the Markdown source is [lake_levels_2026_report.md](lake_levels_2026_report.md)).

![Lake levels on 28 September 2026 compared with every year since 1970](figures/unusualness_per_lake.png)

## Main findings

* 12 of 26 large Swiss lakes were at their lowest late September level since 1970.
* Lakes of the Plateau, the Prealps and the Jura were most affected; lakes fed from the high Alps (Geneva, Thun,
  Brienz, Engadin) stayed close to normal.
* Glacier cover of the watershed explains much of the difference: Lake Brienz still received about 90% of its usual
  summer inflow, Lake Zurich less than a quarter.
* Regulation matters: Lake Geneva kept a normal level by releasing less water, while Lake Zurich fell below its low
  water limit once its inflow dropped below the minimum outflow.
* The lakes had their warmest summer since at least 1981 (about 3 °C above normal) and evaporated much more water
  than usual.

## Repository content

| Path | Content |
|---|---|
| `lake_levels_climatology.ipynb` | Lake level climatology and record lows, inflow reconstruction against glacier cover, weather (MeteoSwiss), maps, SWOT satellite levels |
| `lake_outflow_inflow_climatology.ipynb` | Level, outflow and reconstructed inflow compared for 12 lake systems; Lake Geneva and Lake Zurich; Simstrat surface temperature; evaporation |
| `lake_levels_2026_report.md` / `.pdf` | The report |
| `report/` | PDF build: `build_report.sh`, pandoc filter and LaTeX preamble |
| `figures/` | All figures written by the notebooks (`*_large.png`: larger fonts) |
| `data/` | Downloaded data, cached so the notebooks run offline and reproducibly (see below) |

## How to run

```sh
pip install -r requirements.txt
jupyter nbconvert --to notebook --execute --inplace lake_levels_climatology.ipynb
jupyter nbconvert --to notebook --execute --inplace lake_outflow_inflow_climatology.ipynb
sh report/build_report.sh          # needs pandoc and a LaTeX installation with xelatex
```

Run `lake_levels_climatology.ipynb` first: it downloads the lake levels used by the second notebook.
Both notebooks reuse the cached files in `data/` and only fetch the most recent days. The analysis is frozen on
28 September 2026 by `REPORT_END` at the top of each notebook; set it to `None` to use the latest data.
The SWOT files in `data/SWOT/` were collected through Alplakes and are not downloaded by the notebooks.

## Data sources

| Data | Source | Location in `data/` |
|---|---|---|
| Daily lake levels and river discharge | FOEN, [data.bafu.admin.ch](https://data.bafu.admin.ch/en/) (GraphQL API) | `W_daily_*.csv`, `Q_daily_*.csv` |
| Daily weather | MeteoSwiss open data, [data.geo.admin.ch](https://data.geo.admin.ch/browser/index.html#/collections/ch.meteoschweiz.ogd-smn) | `meteoswiss/` |
| Catchment and glacier attributes | CAMELS-CH, Höge et al. (2023), [doi:10.5281/zenodo.15025258](https://doi.org/10.5281/zenodo.15025258) | `camels_ch/` |
| Lake surface temperature | Simstrat model on [Alplakes](https://www.alplakes.eawag.ch) | `simstrat/` |
| Small lake levels | SWOT (NASA and CNES) lake product, via Alplakes | `SWOT/` |
| Lake outlines, areas, regulation flag | FOEN VECTOR25 lake layer, [map.geo.admin.ch](https://map.geo.admin.ch) | `ch_lakes_vec25.json` |
| Swiss border | swisstopo, swissBOUNDARIES3D | `ch_border.geojson` |

All 2026 values are provisional and may still be revised by the data providers.

## Archive on Zenodo

Each GitHub release is archived on Zenodo. The archive contains the code, the report and the figures, but **not**
the third-party data in `data/` (excluded with `export-ignore` in `.gitattributes`). To reproduce the analysis from
the Zenodo archive, run the notebooks: they download the FOEN, MeteoSwiss, CAMELS-CH, Simstrat and geodata from the
original providers. The SWOT lake levels must be retrieved separately from [Alplakes](https://www.alplakes.eawag.ch)
and placed in `data/SWOT/`.

## Licence

The code, the report and the figures in this repository are released under the [MIT License](LICENSE).
The data in `data/` remain the property of their providers and are redistributed under their own terms
(FOEN, MeteoSwiss and swisstopo open government data with mandatory source attribution; CAMELS-CH under CC BY 4.0).
Please cite the original data sources listed above when reusing them.

## Citation

Bouffard, D. (2026). Swiss lake water levels in the dry summer of 2026: code, report and figures. Zenodo.
https://doi.org/10.5281/zenodo.XXXXXXX (DOI added after the first release)

See also [CITATION.cff](CITATION.cff).

The code was written with the help of AI (Claude).

## Contact

Damien Bouffard, Eawag (Swiss Federal Institute of Aquatic Science and Technology) and University of Lausanne.
