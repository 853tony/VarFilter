import argparse
import pandas as pd

def parse_arguments():
    parser = argparse.ArgumentParser(description='Filter variants by specifying conditions on populations and allele frequencies.', formatter_class=argparse.RawTextHelpFormatter)

    required = parser.add_argument_group('required')

    col = parser.add_argument_group('column name arguments')

    required.add_argument('-p1', '--pop1', type=str, required=True, metavar='', help='Population(s) for condition 1 (comma-separated). Enter "none" to skip condition 1.')
    required.add_argument('-f1', '--af1', type=float, required=True, metavar='', help='''Allele frequency for condition 1 (percentage). Enter "999" to skip condition 1.
 ''')
    parser.add_argument('-e1', '--equal1', type=str, default='TRUE', metavar='', help='''Equality condition for condition 1.
If TRUE, use greater than or equal to for condition 1;
if FALSE, use greater than (>) only (default: TRUE)
 ''')
    parser.add_argument('-l1', '--logic1', type=str, default='all', metavar='', help='''Logical operator for condition 1.
If "all", all populations specified by -p1 must satisfy the condition 1;
if "any", at least one population specified by -p1 must satisfy the condition 1 (default: "all")
 ''')
############################################
    required.add_argument('-p2', '--pop2', type=str, required=True, metavar='', help='Population(s) for condition 2 (comma-separated). Enter "none" to skip condition 2.')
    required.add_argument('-f2', '--af2', type=float, required=True, metavar='', help='''Allele frequency for condition 2 (percentage). Enter "999" to skip condition 2.
 ''')
    parser.add_argument('-e2', '--equal2', type=str, default='TRUE', metavar='', help='''Equality condition for condition 2.
If TRUE, use less than or equal to for condition 2;
if FALSE, use less than (<) only (default: TRUE)
 ''')
    parser.add_argument('-l2', '--logic2', type=str, default='all', metavar='', help='''Logical operator for condition 2.
If "all", all populations specified by -p2 must satisfy the condition 2;
if "any", at least one population specified by -p2 must satisfy the condition 2 (default: "all")
 ''')
############################################
    col.add_argument('-cp', '--col_prefix', type=str, default='', metavar='', help='Prefix for AF column name in the input file (default: empty)')
    col.add_argument('-cs', '--col_suffix', type=str, default='', metavar='', help='Suffix for AF column name in the input file (default: empty)')
############################################
    required.add_argument('-i', '--inp', type=str, required=True, metavar='', help='Input tsv file')
    required.add_argument('-o', '--outp', type=str, required=True, metavar='', help='Output tsv file')
############################################
    parser.add_argument('-m', '--mn', type=str, default='', metavar='', help='Name of the filtering mission')
    parser.add_argument('-FC', '--float_columns', type=str, default='', metavar='', help='Comma-separated list of columns to be treated as floats (default: empty)')
############################################

    return parser.parse_args()

def main():
    args = parse_arguments()

    col_prefix = args.col_prefix
    col_suffix = args.col_suffix
    
    data = pd.read_csv(args.inp, sep='\t', low_memory=False)

    if args.float_columns.strip() != "":
        float_columns = args.float_columns.split(',')
        data[float_columns] = data[float_columns].fillna(0)    


    if args.pop1.strip().lower() != "none" and args.af1 != 999:
        pop1_list = args.pop1.split(',')
        af1 = args.af1 / 100
        equal1 = args.equal1.upper() == 'TRUE'
        logic1 = args.logic1.lower()
        
        op1 = 'ge' if equal1 else 'gt'
        
        filter_condition_1 = data[[f'{col_prefix}{p}{col_suffix}' for p in pop1_list]].__getattribute__(op1)(af1).__getattribute__(logic1)(axis=1)
        condition1_str = f"Condition 1: Population(s) {args.pop1} {'greater than or equal to' if equal1 else 'greater than'} {args.af1}% AF, {logic1} must satisfy."
    else:
        filter_condition_1 = True
        condition1_str = "Condition 1: Not specified."
    
    if args.pop2.strip().lower() != "none" and args.af2 != 999:
        pop2_list = args.pop2.split(',')
        af2 = args.af2 / 100
        equal2 = args.equal2.upper() == 'TRUE'
        logic2 = args.logic2.lower()
        
        op2 = 'le' if equal2 else 'lt'
        
        filter_condition_2 = data[[f'{col_prefix}{p}{col_suffix}' for p in pop2_list]].__getattribute__(op2)(af2).__getattribute__(logic2)(axis=1)
        condition2_str = f"Condition 2: Population(s) {args.pop2} {'less than or equal to' if equal2 else 'less than'} {args.af2}% AF, {logic2} must satisfy."

    else:
        filter_condition_2 = True
        condition2_str = "Condition 2: Not specified."

    if args.mn:
        print(f"Mission: {args.mn}")
    print("Filtering conditions:")
    print(condition1_str)
    print(condition2_str)
    print()

    if filter_condition_1 is True and filter_condition_2 is True:
        print("Error: At least one filtering condition must be specified.")
        return
    elif filter_condition_1 is True:
        filtered_data = data[filter_condition_2]
    elif filter_condition_2 is True:
        filtered_data = data[filter_condition_1]
    else:
        filtered_data = data[filter_condition_1 & filter_condition_2]
    
    filtered_data.to_csv(args.outp, index=False, sep='\t')

if __name__ == '__main__':
    main()
