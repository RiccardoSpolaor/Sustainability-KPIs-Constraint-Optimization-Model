# :earth_africa: Sustainability KPIs Constraint Optimization Model :recycle:
A constraint programming model in `Minizinc` which aims at maximizing the score of a series of environmental KPIs of a company, while making sure given production constraints are satisfied (e.g.: minimum  earnings are achieved; production times are respected).

The program has been implemented in such a way that it can be customized for different types of companies and production goals.
In particular the user is asked to input a series of business related parameters, which are then considered for satisfying the constraints and in the concurring KPIs maximization task. 

## Repository structure

    .
    ├── data
    │   └── input_example.dzn   # Input data example describing a paper production company
    ├── report                       
    │   └── report.pdf          # Report about the project 
    ├── .gitattributes
    ├── .gitignore
    ├── LICENSE
    ├── README.md
    ├── constants.mzn           # MiniZinc file defining the constants parameters of the model 
    ├── constraints.mzn         # MiniZinc file defining the constraints of the model
    ├── functions.mzn           # MiniZinc file defining useful functions for the model
    ├── main.mzn                # MiniZinc file containing the model definition
    ├── parameters.mzn          # MiniZinc file defining the input parameters of the model
    └── variables.mzn           # MiniZinc file defining the variables  of the model

## Usage
* Download the *Minizinc IDE*: https://www.minizinc.org/ide/;
* Download this repository and open the project with the *Minizinc IDE*;
* Open the `main.mzn` file and run the *Minizinc IDE*;
* Either provide the requested input data manually, or use the example file in `./data/input_example.dzn` or create a new `.dzn` file with personalized information about the company.

## Specifics
The program has been tested with the solver `Gecode 6.3.0` because of its general purpose characteristics.

## Versioning

Git is used for versioning.

## Group members

|  Name           |  Surname  |     Email                           |    Username                                             |
| :-------------: | :-------: | :---------------------------------: | :-----------------------------------------------------: |
| Facundo Nicolas | Maidana   | `facundo.maidana@studio.unibo.it`   | [_maidacundo_](https://github.com/maidacundo)           |
| Riccardo        | Spolaor   | `riccardo.spolaor@studio.unibo.it`  | [_RiccardoSpolaor_](https://github.com/RiccardoSpolaor) |
| Stefano         | Ciapponi  | `stefano.ciapponi@studio.unibo.it`  | [_drchapman-17_](https://github.com/drchapman-17)       |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Social preview image licensed by [Nature Vectors by Vecteezy](https://www.vecteezy.com/free-vector/nature).
