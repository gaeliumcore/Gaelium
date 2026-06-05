// Copyright (c) 2011-2016 The Bitcoin Core developers
// Copyright (c) 2017-2021 The Gaelium Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef GAELIUM_QT_GUICONSTANTS_H
#define GAELIUM_QT_GUICONSTANTS_H

/* Milliseconds between model updates */
static const int MODEL_UPDATE_DELAY = 250;

/* AskPassphraseDialog -- Maximum passphrase length */
static const int MAX_PASSPHRASE_SIZE = 1024;

/* GaeliumGUI -- Size of icons in status bar */
static const int STATUSBAR_ICONSIZE = 16;

static const bool DEFAULT_SPLASHSCREEN = true;

/* Invalid field background style */
#define STYLE_INVALID "background:#FF8080; border: 1px solid lightgray; padding: 0px;"
#define STYLE_VALID "border: 1px solid lightgray; padding: 0px;"

/* Transaction list -- unconfirmed transaction */
#define COLOR_UNCONFIRMED QColor(128, 128, 128)
/* Transaction list -- negative amount */
#define COLOR_NEGATIVE QColor(231, 76, 94)
/* Transaction list -- bare address (without label) */
#define COLOR_BAREADDRESS QColor(138, 148, 168)
/* Transaction list -- TX status decoration - open until date */
#define COLOR_TX_STATUS_OPENUNTILDATE QColor(13, 181, 132)
/* Transaction list -- TX status decoration - danger, tx needs attention */
#define COLOR_TX_STATUS_DANGER QColor(231, 76, 94)
/* Transaction list -- TX status decoration - default color */
#define COLOR_BLACK QColor(10, 15, 26)
/* Widget Background color - default color */
#define COLOR_WHITE QColor(232, 236, 244)

#define COLOR_WALLETFRAME_SHADOW QColor(0,0,0,90)

/* Color of labels */
#define COLOR_LABELS QColor("#0db584")

/** LIGHT MODE (kept for compatibility but Gaelium uses dark mode) */
#define COLOR_BACKGROUND_LIGHT QColor("#0a0f1a")
#define COLOR_DARK_ORANGE QColor("#0db584")
#define COLOR_LIGHT_ORANGE QColor("#088a63")
#define COLOR_DARK_BLUE QColor("#384192")
#define COLOR_LIGHT_BLUE QColor("#4a54b0")
#define COLOR_ASSET_TEXT QColor(232, 236, 244)
#define COLOR_SHADOW_LIGHT QColor("#050810")
#define COLOR_TOOLBAR_NOT_SELECTED_TEXT QColor("#8a94a8")
#define COLOR_TOOLBAR_SELECTED_TEXT COLOR_WHITE
#define COLOR_SENDENTRIES_BACKGROUND QColor("#0a0f1a")

/** DARK MODE — GAELIUM MODERN THEME */
/* Main widget background */
#define COLOR_WIDGET_BACKGROUND_DARK QColor("#111827")
/* Shadow color */
#define COLOR_SHADOW_DARK QColor("#050810")
/* Sidebar gradient top */
#define COLOR_LIGHT_BLUE_DARK QColor("#111827")
/* Sidebar gradient bottom */
#define COLOR_DARK_BLUE_DARK QColor("#0a0f1a")
/* Header/pricing widget background */
#define COLOR_PRICING_WIDGET QColor("#111827")
/* Admin card background */
#define COLOR_ADMIN_CARD_DARK QColor(10, 15, 26)
/* Regular card backgrounds */
#define COLOR_REGULAR_CARD_DARK_BLUE_DARK_MODE QColor("#0a0f1a")
#define COLOR_REGULAR_CARD_LIGHT_BLUE_DARK_MODE QColor("#111827")
/* Sidebar text - not selected */
#define COLOR_TOOLBAR_NOT_SELECTED_TEXT_DARK_MODE QColor("#8a94a8")
/* Sidebar text - selected (green accent) */
#define COLOR_TOOLBAR_SELECTED_TEXT_DARK_MODE QColor("#0db584")
/* Send entries background */
#define COLOR_SENDENTRIES_BACKGROUND_DARK QColor("#111827")

/* Gaelium label color as a string */
#define STRING_LABEL_COLOR "color: #0db584"
#define STRING_LABEL_COLOR_WARNING "color: #e74c5e"

/* Tooltips longer than this (in characters) are converted into rich text,
   so that they can be word-wrapped.
 */
static const int TOOLTIP_WRAP_THRESHOLD = 80;

/* Maximum allowed URI length */
static const int MAX_URI_LENGTH = 255;

/* QRCodeDialog -- size of exported QR Code image */
#define QR_IMAGE_SIZE 300

/* Number of frames in spinner animation */
#define SPINNER_FRAMES 36

#define QAPP_ORG_NAME "Gaelium"
#define QAPP_ORG_DOMAIN "gaelium.io"
#define QAPP_APP_NAME_DEFAULT "Gaelium-Qt"
#define QAPP_APP_NAME_TESTNET "Gaelium-Qt-testnet"

/* Default third party browser urls */
#define DEFAULT_THIRD_PARTY_BROWSERS "https://explorer.gaelium.io/tx/%s"

/* Default IPFS viewer */
#define DEFAULT_IPFS_VIEWER "https://ipfs.io/ipfs/%s"

#endif // GAELIUM_QT_GUICONSTANTS_H
