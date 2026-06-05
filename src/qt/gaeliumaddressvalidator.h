// Copyright (c) 2011-2014 The Bitcoin Core developers
// Copyright (c) 2017-2019 The Gaelium Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef GAELIUM_QT_GAELIUMADDRESSVALIDATOR_H
#define GAELIUM_QT_GAELIUMADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class GaeliumAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit GaeliumAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** Gaelium address widget validator, checks for a valid gaelium address.
 */
class GaeliumAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit GaeliumAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // GAELIUM_QT_GAELIUMADDRESSVALIDATOR_H
