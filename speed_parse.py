#!/usr/bin/python3
# -*- coding: UTF-8 -*-

import time
import argparse
import parse
import pymysql

now=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
parser = argparse.ArgumentParser(description='Parsing babassl speed test result and saving to the rds')
parser.add_argument('-c', '--commit', help='git my commit id')
parser.add_argument('-l', '--last_commit', help='git last commit id')
parser.add_argument('-d', '--date', help='speed test date, for example: 2022-02-11 11:22:33')
parser.add_argument('-j', '--job-date', help='run job date, for example: 2022-02-11 11:22:33')
parser.add_argument('-f', '--file', required=True, help='speed test result file')
parser.add_argument('-t', '--type', required=True, type=str,
                    choices=["symmetric_encryption", "asymmetric_encryption", "signature", "digest", "key_exchange", "phe"],
                    help='speed test algorithm type')
parser.add_argument('--mysql-host', required=True, help='mysql host')
parser.add_argument('--mysql-user', required=True, help='mysql user')
parser.add_argument('--mysql-password', required=True, help='mysql password')
parser.add_argument('--mysql-db', required=True, help='mysql db')
parser.add_argument('--mysql-port', required=False, type=int, default=3306, help='mysql port')
args = parser.parse_args()
commit = args.commit if args.commit else ''
last_commit = args.last_commit if args.last_commit else ''
date = args.date if args.date else now
job_date = args.job_date if args.job_date else now

def str2int(s):
    if s == '':
        return 0
    return int(float(s[0:-1]) * 1000 if s[-1] == 'k' else float(s[0:-1]))

def symmetric_encryption_result_parse_to_sql(line):
    result = parse.parse('{algo:^} {:^} {:^} {:^} {:^} {:^} {}', line.strip())
    if result is None:
        return None

    if result['algo'] == 'type':
        return None

    return """insert into symmetric_encryption (last_commit, my_commit, algorithm,
              bytes16, bytes64, bytes256, bytes1024, bytes8192,
              date, job_date) values ('{0}', '{1}', '{2}', {3}, {4}, {5}, {6}, {7},
              '{8}', {9})""".format(last_commit, commit, result["algo"],
                                    str2int(result[0]), str2int(result[1]),
                                    str2int(result[2]), str2int(result[3]),
                                    str2int(result[4]), date, job_date)

def asymmetric_encryption_result_parse_to_sql(line):
    result = parse.parse('{algo:^} {:^} {:^} {:^} {:^} {}', line.strip())
    if result is None:
        return None

    return """insert into symmetric_encryption (last_commit, my_commit, algorithm,
              bytes16, bytes64, bytes256, bytes1024, bytes8192,
              date, job_date) values ('{0}', '{1}', '{2}', {3}, {4}, {5}, {6}, {7},
              '{8}', {9})""".format(last_commit, commit, result["algo"],
                                    str2int(result[0]), str2int(result[1]),
                                    str2int(result[2]), str2int(result[3]),
                                    str2int(result[4]), date, job_date)

def signature_result_parse_to_sql(line):
    result = parse.parse('{algo:>} {:>F}s {:>F}s {:>F} {:>F}', line.strip())
    if result is None:
        return None

    return """insert into signature (last_commit, my_commit, algorithm,
              sign_time, verify_time, sign_qps, verify_qps,
              date, job_date) values ('{0}', '{1}', '{2}', {3}, {4}, {5}, {6},
              '{7}', {8})""".format(last_commit, commit, result["algo"], result[0],
                                    result[1], result[2], result[3], date, job_date)

def digest_result_parse_to_sql(line):
    result = parse.parse('{algo:^} {:^} {:^} {:^} {:^} {:^} {}', line.strip())
    if result is None:
        return None

    if result["algo"] == "type":
        return None

    return """insert into digest (last_commit, my_commit, algorithm,
              bytes16, bytes64, bytes256, bytes1024, bytes8192, bytes16384,
              date, job_date) values ('{0}', '{1}', '{2}', {3}, {4}, {5}, {6}, {7},
              {8}, '{9}', {10})""".format(last_commit, commit, result["algo"],
                                          str2int(result[0]), str2int(result[1]),
                                          str2int(result[2]), str2int(result[3]),
                                          str2int(result[4]), str2int(result[5]),
                                          date, job_date)

def key_exchange_result_parse_to_sql(line):
    result = parse.parse('{algo:>} {:>F}s {:>F}', line.strip())
    if result is None:
        return None

    if result["algo"] == "type":
        return None

    return """insert into key_exchange (last_commit, my_commit, algorithm,
              op_time, op_qps, date, job_date) values ('{0}', '{1}', '{2}', {3},
              {4}, '{5}', {6})""".format(last_commit, commit, result["algo"],
                                         result[0], result[1], date, job_date)

def phe_result_parse_to_sql(line):
    result = parse.parse('{algo:>} {:>d} {:>d} {:>F} {:>F} {:>F} {:>F} {:>F}',
                         line.strip())
    if result is None:
        return None

    return """insert into phe (last_commit, my_commit, algorithm, a, b,
              encrypt_qps, decrypt_qps, add_qps, sub_qps, scalar_mul_qps,
              date, job_date) values ('{0}', '{1}', '{2}', {3}, {4}, {5}, {6}, {7},
              {8}, {9}, '{10}', {11})""".format(last_commit, commit, result["algo"],
                                                result[0], result[1], result[2],
                                                result[3], result[4], result[5],
                                                result[6], date, job_date)

parse_dict = {
    "symmetric_encryption": symmetric_encryption_result_parse_to_sql,
    "asymmetric_encryption": asymmetric_encryption_result_parse_to_sql,
    "signature": signature_result_parse_to_sql,
    "digest": digest_result_parse_to_sql,
    "key_exchange": key_exchange_result_parse_to_sql,
    "phe": phe_result_parse_to_sql,
}

def main():
    #try:
        global last_commit
        global date

        db_conn = pymysql.connect(host=args.mysql_host,
                                  user=args.mysql_user, password=args.mysql_password,
                                  db=args.mysql_db, port=args.mysql_port, charset='utf8')

        cursor = db_conn.cursor()

        parse_func = parse_dict[args.type]

        with open(args.file) as file_in:
            for line in file_in:
                result = parse.parse('commit: {:>}', line)
                if result is not None:
                    last_commit = result[0].strip()

                result = parse.parse('date: {:>}', line)
                if result is not None:
                    date = result[0].strip()

                sql = parse_func(line)
                if sql is None:
                    continue

                print(sql)
                cursor.execute(sql)

            db_conn.commit()

        db_conn.close()
        print("success!")
    #except Exception as e:
    #    print("process failed: ", e)

    #return

if __name__ == "__main__":
    main()

