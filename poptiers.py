import argparse, glob, os
from praatio import textgrid

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", required=True, type=str, help="Input directory")
    parser.add_argument("-t", "--tier_name", required=True, type=str, help="Tier name")
    args = parser.parse_args()

    grids = glob.glob(os.path.join(os.path.abspath(args.input), "**/*.TextGrid"), recursive=True)

    print(f"popping tier \"{args.tier_name}\" from {len(grids)} grids")

    for gridpath in grids:
        grid = textgrid.openTextgrid(gridpath, includeEmptyIntervals=True)

        try:
            grid.getTier(args.tier_name)
            grid.removeTier(args.tier_name)
            grid.save(gridpath, includeBlankSpaces=True, format="long_textgrid")
        except KeyError as e:
            print(f"skipping {gridpath}: tier {args.tier_name} not found")
        except Exception as e:
            print(f"unexpected error {gridpath}: {e}")